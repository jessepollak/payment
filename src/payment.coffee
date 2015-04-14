QJ = require 'qj'

defaultFormat = /(\d{1,4})/g

cards = [
  {
      type: 'amex'
      pattern: /^3[47]/
      format: /(\d{1,4})(\d{1,6})?(\d{1,5})?/
      length: [15]
      cvcLength: [3..4]
      luhn: true
  }
  {
      type: 'dankort',
      pattern: /^5019/,
      format: defaultFormat,
      length: [16],
      cvcLength: [3],
      luhn: true
  }
  {
      type: 'dinersclub'
      pattern: /^(30[0-5]|3095|36|38|39)/
      format: /(\d{1,4})(\d{1,6})?(\d{1,4})?/
      length: [14]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'discover'
      pattern: /^(6011|64[4-9]|65)/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'jcb'
      pattern: /^(352[8-9]|35[3-8])/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'maestro'
      pattern: /^(500[0-9]|501[0-8]|50[2-7]|508[0-4]|5[6-9]|60[0-5]|6060|61|63|64[0-3]|6[7-9])/
      format: defaultFormat
      length: [12..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'mastercard'
      pattern: /^5[1-5]/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'unionpay'
      pattern: /^62/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: false
  }
  {
      type: 'visaelectron',
      pattern: /^4(026|17500|405|508|844|91[37])/,
      format: defaultFormat,
      length: [16],
      cvcLength: [3],
      luhn: true
  }
  {
      type: 'visa'
      pattern: /^4/
      format: defaultFormat
      length: [13..16]
      cvcLength: [3]
      luhn: true
  }
]

# Store HTML elements (passed onto formatters)
# for re-use by other methods
elements = []

cardFromNumber = (num) ->
  num = (num + '').replace(/\D/g, '')
  return card for card in cards when card.pattern.test(num)

cardFromType = (type) ->
  return card for card in cards when card.type is type

luhnCheck = (num) ->
  odd = true
  sum = 0

  digits = (num + '').split('').reverse()

  for digit in digits
    digit = parseInt(digit, 10)
    digit *= 2 if (odd = !odd)
    digit -= 9 if digit > 9
    sum += digit

  sum % 10 == 0

hasTextSelected = (target) ->
  # If some text is selected
  return true if target.selectionStart? and
    target.selectionStart isnt target.selectionEnd

  # If some text is selected in IE
  if document?.selection?.createRange?
    return true if document.selection.createRange().text

  false

# Private

# Format Card Number

reFormatCardNumber = (e) ->
  setTimeout =>
    target  = e.target
    value   = QJ.val(target)

    # clear the value
    QJ.val target, ''

    # Iterate over the string and simulate
    # key event to trigger formatCardNumber
    for char,idx in value
      code = char.charCodeAt(0)

      # Firefox
      try
        keyEvent = document.createEvent 'KeyEvents'
        keyEvent.initKeyEvent 'keypress', true, true, window, false, false, false, false, code, code
      catch FirefoxException
        console.log 'Unable to create KeyEvents event:' + FirefoxException.message

        # Chromium
        try
          keyEvent = document.createEvent 'KeyboardEvent'

          Object.defineProperty keyEvent, 'keyCode', get: -> @keyCodeVal
          Object.defineProperty keyEvent, 'which', get: -> @keyCodeVal

          keyEvent.initKeyboardEvent 'keypress', true, true, document.defaultView, false, false, false, false, code, code

          keyEvent.keyCodeVal = code
        catch ChromeException
          console.log 'Unable to create KeyboardEvent event: ' + ChromeException.message

      if keyEvent
        target.dispatchEvent keyEvent
      else if document.createEventObject
        # IE
        keyEvent = document.createEventObject 'KeyboardEvent'
        keyEvent.keyCode = code
        target.fireEvent 'onkeyup', keyEvent

    # Trigger keyup, thus triggering detection
    QJ.trigger target, 'keyup'

formatCardNumber = (e) ->
  # Only format if input is a number
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  target  = e.target
  value   = QJ.val(target)
  card    = cardFromNumber(value + digit)
  length  = (value.replace(/\D/g, '') + digit).length

  upperLength = 16
  upperLength = card.length[card.length.length - 1] if card
  return if length > upperLength

  # Return if focus isn't at the end of the text
  return if target.selectionStart? and
    target.selectionStart isnt value.length

  value = (value + digit).replace /[^\d]/g, ''

  switch length
    when 13 then re = /(\d{6})(\d{4})(\d{3})/
    when 14 then re = /(\d{4})(\d{6})(\d{4})/
    when 15 then re = /(\d{4})(\d{6})(\d{5})/
    when 17 then re = /(\d{4})(\d{4})(\d{4})(\d{4})(\d{1})/
    when 18 then re = /(\d{4})(\d{4})(\d{4})(\d{6})/
    when 19 then re = /(\d{6})(\d{13})/
    else re = /(\d{4})/

  e.preventDefault()

  # Note: filter is not available in IE8
  QJ.val target, value.split(re).filter((val) -> val.length isnt 0).join(' ')

formatBackCardNumber = (e) ->
  target = e.target
  value   = QJ.val(target)

  return if e.meta

  # Return unless backspacing
  return unless e.which is 8

  # Return if focus isn't at the end of the text
  return if target.selectionStart? and
    target.selectionStart isnt value.length

  # Remove the trailing space
  if /\d\s$/.test(value)
    e.preventDefault()
    QJ.val(target, value.replace(/\d\s$/, ''))
  else if /\s\d?$/.test(value)
    e.preventDefault()
    QJ.val(target, value.replace(/\s\d?$/, ''))

# Format Expiry

formatExpiry = (e) ->
  # Only format if input is a number
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  target = e.target
  val     = QJ.val(target) + digit

  if /^\d$/.test(val) and val not in ['0', '1']
    e.preventDefault()
    QJ.val(target, "0#{val} / ")

  else if /^\d\d$/.test(val)
    e.preventDefault()
    QJ.val(target, "#{val} / ")

formatForwardExpiry = (e) ->
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  target = e.target
  val     = QJ.val(target)

  if /^\d\d$/.test(val)
    QJ.val(target, "#{val} / ")

formatForwardSlash = (e) ->
  slash = String.fromCharCode(e.which)
  return unless slash is '/'

  target = e.target
  val     = QJ.val(target)

  if /^\d$/.test(val) and val isnt '0'
    QJ.val(target, "0#{val} / ")

formatBackExpiry = (e) ->
  # If shift+backspace is pressed
  return if e.metaKey

  target = e.target
  value   = QJ.val(target)

  # Return unless backspacing
  return unless e.which is 8

  # Return if focus isn't at the end of the text
  return if target.selectionStart? and
    target.selectionStart isnt value.length

  # Remove the trailing space
  if /\d(\s|\/)+$/.test(value)
    e.preventDefault()
    QJ.val(target, value.replace(/\d(\s|\/)*$/, ''))
  else if /\s\/\s?\d?$/.test(value)
    e.preventDefault()
    QJ.val(target, value.replace(/\s\/\s?\d?$/, ''))

#  Restrictions

restrictNumeric = (e) ->
  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return e.preventDefault() if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  # Char is a number or a space
  return e.preventDefault() if !/[\d\s]/.test(input)

restrictCardNumber = (e) ->
  target  = e.target
  digit   = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  return if hasTextSelected(target)

  # Restrict number of digits
  value = (QJ.val(target) + digit).replace(/\D/g, '')
  card  = cardFromNumber(value)

  if card
    e.preventDefault() unless value.length <= card.length[card.length.length - 1]
  else
    # All other cards are 16 digits long
    e.preventDefault() unless value.length <= 16

restrictExpiry = (e) ->
  target  = e.target
  digit   = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  return if hasTextSelected(target)

  value = QJ.val(target) + digit
  value = value.replace(/\D/g, '')

  return e.preventDefault() if value.length > 6

restrictCVC = (e) ->
  target  = e.target
  digit   = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  numberEl = Payment.getElement 'number'

  if numberEl
    cardNumber = ''

    # Expecting a NodeList and concat
    # the values of all elements
    for el in numberEl
      cardNumber += QJ.val el

    cardObj = cardFromNumber(cardNumber)

    if cardObj
      cvcLength = Math.max.apply Math, cardObj.cvcLength
    else
      cvcLength = 4
  else
    cvcLength = 4

  val     = QJ.val(target) + digit
  return e.preventDefault() unless val.length <= cvcLength

setCardType = (e) ->
  target  = e.target
  val      = QJ.val(target)
  cardType = Payment.fns.cardType(val) or 'unknown'

  unless QJ.hasClass(target, cardType)
    allTypes = (card.type for card in cards)

    QJ.removeClass target, 'unknown'
    QJ.removeClass target, allTypes.join(' ')

    QJ.addClass target, cardType
    QJ.toggleClass target, 'identified', cardType isnt 'unknown'
    QJ.trigger target, 'payment.cardType', cardType

# Public

class Payment
  @fns:
    cardExpiryVal: (value) ->
      value = value.replace(/\s/g, '')
      [month, year] = value.split('/', 2)

      # Allow for year shortcut
      if year?.length is 2 and /^\d+$/.test(year)
        prefix = (new Date).getFullYear()
        prefix = prefix.toString()[0..1]
        year   = prefix + year

      month = parseInt(month, 10)
      year  = parseInt(year, 10)

      month: month, year: year
    validateCardNumber: (num) ->
      num = (num + '').replace(/\s+|-/g, '')
      return false unless /^\d+$/.test(num)

      card = cardFromNumber(num)
      return false unless card

      num.length in card.length and
        (card.luhn is false or luhnCheck(num))
    validateCardExpiry: (month, year) ->
      # Allow passing an object
      if typeof month is 'object' and 'month' of month
        {month, year} = month

      return false unless month and year

      month = QJ.trim(month)
      year  = QJ.trim(year)

      return false unless /^\d+$/.test(month)
      return false unless /^\d+$/.test(year)
      return false unless parseInt(month, 10) <= 12

      if year.length is 2
        prefix = (new Date).getFullYear()
        prefix = prefix.toString()[0..1]
        year   = prefix + year

      expiry      = new Date(year, month)
      currentTime = new Date

      # Months start from 0 in JavaScript
      expiry.setMonth(expiry.getMonth() - 1)

      # The cc expires at the end of the month,
      # so we need to make the expiry the first day
      # of the month after
      expiry.setMonth(expiry.getMonth() + 1, 1)

      expiry > currentTime
    validateCardCVC: (cvc, type) ->
      cvc = QJ.trim(cvc)
      return false unless /^\d+$/.test(cvc)

      if type and cardFromType(type)
        # Check against a explicit card type
        cvc.length in cardFromType(type)?.cvcLength
      else
        # Check against all types
        cvc.length >= 3 and cvc.length <= 4
    cardType: (num) ->
      return null unless num
      cardFromNumber(num)?.type or null
    formatCardNumber: (num) ->
      card = cardFromNumber(num)
      return num unless card

      upperLength = card.length[card.length.length - 1]

      num = num.replace(/\D/g, '')
      num = num[0..upperLength]

      if card.format.global
        num.match(card.format)?.join(' ')
      else
        groups = card.format.exec(num)
        groups?.shift()
        groups?.join(' ')
  @restrictNumeric: (el) ->
    QJ.on el, 'keypress', restrictNumeric
  @cardExpiryVal: (el) ->
    Payment.fns.cardExpiryVal(QJ.val(el))
  @formatCardCVC: (el) ->
    Payment.restrictNumeric el
    QJ.on el, 'keypress', restrictCVC
    @storeElement 'cvc', el
    el
  @formatCardExpiry: (el) ->
    Payment.restrictNumeric el
    QJ.on el, 'keypress', restrictExpiry
    QJ.on el, 'keypress', formatExpiry
    QJ.on el, 'keypress', formatForwardSlash
    QJ.on el, 'keypress', formatForwardExpiry
    QJ.on el, 'keydown', formatBackExpiry
    @storeElement 'expiry', el
    el
  @formatCardNumber: (el) ->
    Payment.restrictNumeric el
    QJ.on el, 'keypress', restrictCardNumber
    QJ.on el, 'keypress', formatCardNumber
    QJ.on el, 'keydown', formatBackCardNumber
    QJ.on el, 'keyup', setCardType
    QJ.on el, 'paste', reFormatCardNumber
    @storeElement 'number', el
    el

  @getCardArray: ->
    cards
  @setCardArray: (cardArray) ->
    cards = cardArray
  @addToCardArray: (cardObject) ->
    cards.push(cardObject)
  @removeFromCardArray: (type) ->
    cards.splice key, 1 for key, value of cards when value.type is type

  @getElement: (name) ->
    elements["#{name}"]
  @storeElement: (name, el) ->
    elements["#{name}"] = el

module.exports = Payment
global.Payment = Payment
