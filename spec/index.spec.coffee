assert = require('assert')

Payment = require('../src/index')
QJ = require('qj')

describe 'payment', ->
  describe 'Validating a card number', ->
    it 'should fail if empty', ->
      topic = Payment.fns.validateCardNumber ''
      assert.equal topic, false

    it 'should fail if is a bunch of spaces', ->
      topic = Payment.fns.validateCardNumber '                 '
      assert.equal topic, false

    it 'should success if is valid', ->
      topic = Payment.fns.validateCardNumber '4242424242424242'
      assert.equal topic, true

    it 'that has dashes in it but is valid', ->
      topic = Payment.fns.validateCardNumber '4242-4242-4242-4242'
      assert.equal topic, true

    it 'should succeed if it has spaces in it but is valid', ->
      topic = Payment.fns.validateCardNumber '4242 4242 4242 4242'
      assert.equal topic, true

    it 'that does not pass the luhn checker', ->
      topic = Payment.fns.validateCardNumber '4242424242424241'
      assert.equal topic, false

    it 'should fail if is more than 16 digits', ->
      topic = Payment.fns.validateCardNumber '42424242424242424'
      assert.equal topic, false

    it 'should fail if is less than 10 digits', ->
      topic = Payment.fns.validateCardNumber '424242424'
      assert.equal topic, false

    it 'should fail with non-digits', ->
      topic = Payment.fns.validateCardNumber '4242424e42424241'
      assert.equal topic, false

  describe 'validating card types', ->
    it 'should validate amex card types', ->
      assert(Payment.fns.validateCardNumber('378282246310005'), 'amex')
      assert(Payment.fns.validateCardNumber('371449635398431'), 'amex')
      assert(Payment.fns.validateCardNumber('378734493671000'), 'amex')
    it 'should validate dankort card types', ->
      assert(Payment.fns.validateCardNumber('5019123456789013'), 'dankort')
    it 'should validate dinersclub card types', ->
      assert(Payment.fns.validateCardNumber('30569309025904'), 'dinersclub')
      assert(Payment.fns.validateCardNumber('38520000023237'), 'dinersclub')
    it 'should validate discover card types', ->
      assert(Payment.fns.validateCardNumber('6011111111111117'), 'discover')
      assert(Payment.fns.validateCardNumber('6011000990139424'), 'discover')
      assert(Payment.fns.validateCardNumber('6011694113206922182'), 'discover')
    it 'should validate jcb card types', ->
      assert(Payment.fns.validateCardNumber('3530111333300000'), 'jcb')
      assert(Payment.fns.validateCardNumber('3566002020360505'), 'jcb')
    it 'should validate mastercard card types', ->
      assert(Payment.fns.validateCardNumber('5555555555554444'), 'mastercard')
      assert(Payment.fns.validateCardNumber('2221000010000015'), 'mastercard')
    it 'should validate visa card types', ->
      assert(Payment.fns.validateCardNumber('4111111111111111'), 'visa')
      assert(Payment.fns.validateCardNumber('4012888888881881'), 'visa')
      assert(Payment.fns.validateCardNumber('4222222222222'), 'visa')
      assert(Payment.fns.validateCardNumber('4000 0000 0000 0000 030'), 'visa')
    it 'should validate visaelectron card types', ->
      assert(Payment.fns.validateCardNumber('4917300800000000'), 'visaelectron')
    it 'should validate unionpay card types', ->
      assert(Payment.fns.validateCardNumber('6271136264806203568'), 'unionpay')
      assert(Payment.fns.validateCardNumber('6236265930072952775'), 'unionpay')
      assert(Payment.fns.validateCardNumber('6204679475679144515'), 'unionpay')
      assert(Payment.fns.validateCardNumber('6216657720782466507'), 'unionpay')
    it 'should validate maestro card types', ->
      assert(Payment.fns.validateCardNumber('6759649826438453'), 'maestro')
      assert(Payment.fns.validateCardNumber('6759 4111 0000 0008'), 'maestro')
      assert(Payment.fns.validateCardNumber('6759 6498 2643 8453'), 'maestro')
    it 'should validate hipercard card types', ->
      assert(Payment.fns.validateCardNumber('6062821086773091'), 'hipercard')
      assert(Payment.fns.validateCardNumber('6375683647504601'), 'hipercard')
      assert(Payment.fns.validateCardNumber('6370957513839696'), 'hipercard')
      assert(Payment.fns.validateCardNumber('6375688248373892'), 'hipercard')
      assert(Payment.fns.validateCardNumber('6012135281693108'), 'hipercard')
      assert(Payment.fns.validateCardNumber('38410036464094'), 'hipercard')
      assert(Payment.fns.validateCardNumber('38414050328938'), 'hipercard')

  describe 'Validating a CVC', ->
    it 'should fail if is empty', ->
      topic = Payment.fns.validateCardCVC ''
      assert.equal topic, false

    it 'should pass if is valid', ->
      topic = Payment.fns.validateCardCVC '123'
      assert.equal topic, true

    it 'should fail with non-digits', ->
      topic = Payment.fns.validateCardNumber '12e'
      assert.equal topic, false

    it 'should fail with less than 3 digits', ->
      topic = Payment.fns.validateCardNumber '12'
      assert.equal topic, false

    it 'should fail with more than 4 digits', ->
      topic = Payment.fns.validateCardNumber '12345'
      assert.equal topic, false

  describe 'Validating an expiration date', ->
    it 'should fail expires is before the current year', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear() - 1
      assert.equal topic, false

    it 'that expires in the current year but before current month', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry currentTime.getMonth(), currentTime.getFullYear()
      assert.equal topic, false

    it 'that has an invalid month', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry 0, currentTime.getFullYear()
      assert.equal topic, false

    it 'that has an invalid month', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry 13, currentTime.getFullYear()
      assert.equal topic, false

    it 'that is this year and month', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear()
      assert.equal topic, true

    it 'that is just after this month', ->
      # Remember - months start with 0 in JavaScript!
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear()
      assert.equal topic, true

    it 'that is after this year', ->
      currentTime = new Date()
      topic = Payment.fns.validateCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear() + 1
      assert.equal topic, true

    it 'that has string numbers', ->
      currentTime = new Date()
      currentTime.setFullYear(currentTime.getFullYear() + 1, currentTime.getMonth() + 2)
      topic = Payment.fns.validateCardExpiry currentTime.getMonth() + '', currentTime.getFullYear() + ''
      assert.equal topic, true

    it 'should validate a string with two digits month and year delimited by slash', ->
      topic = Payment.fns.validateCardExpiry '03 / 25'
      assert.equal topic, true

    it 'should validate a string with two digits month and four digits year delimited by slash', ->
      topic = Payment.fns.validateCardExpiry '03 / 2025'
      assert.equal topic, true

    it 'should fail if expires is string mm/yyyy where the year is before the current year', ->
      topic = Payment.fns.validateCardExpiry '03 / 205'
      assert.equal topic, false

    it 'that has non-numbers', ->
      topic = Payment.fns.validateCardExpiry 'h12', '3300'
      assert.equal topic, false

    it 'should fail if year or month is NaN', ->
      topic = Payment.fns.validateCardExpiry '12', NaN
      assert.equal topic, false

    it 'should support year shorthand', ->
      assert.equal Payment.fns.validateCardExpiry('05', '20'), true

  describe 'Validating a CVC number', ->
    it 'should validate a three digit number with no card type', ->
      topic = Payment.fns.validateCardCVC('123')
      assert.equal topic, true

    it 'should not validate a three digit number with card type amex', ->
      topic = Payment.fns.validateCardCVC('123', 'amex')
      assert.equal topic, false

    it 'should validate a three digit number with card type other than amex', ->
      topic = Payment.fns.validateCardCVC('123', 'visa')
      assert.equal topic, true

    it 'should not validate a four digit number with a card type other than amex', ->
      topic = Payment.fns.validateCardCVC('1234', 'visa')
      assert.equal topic, false

    it 'should validate a four digit number with card type amex', ->
      topic = Payment.fns.validateCardCVC('1234', 'amex')
      assert.equal topic, true

    it 'should not validate a number larger than 4 digits', ->
      topic = Payment.fns.validateCardCVC('12344')
      assert.equal topic, false

  describe 'Parsing an expiry value', ->
    it 'should parse string expiry', ->
      topic = Payment.fns.cardExpiryVal('03 / 2025')
      assert.deepEqual topic, month: 3, year: 2025

    it 'should support shorthand year', ->
      topic = Payment.fns.cardExpiryVal('05/04')
      assert.deepEqual topic, month: 5, year: 2004

    it 'should return NaN when it cannot parse', ->
      topic = Payment.fns.cardExpiryVal('05/dd')
      assert isNaN(topic.year)

  describe 'Getting a card type', ->
    it 'should return Visa that begins with 40', ->
      topic = Payment.fns.cardType '4012121212121212'
      assert.equal topic, 'visa'

    it 'that begins with 5 should return MasterCard', ->
      topic = Payment.fns.cardType '5555555555554444'
      assert.equal topic, 'mastercard'

    it 'that begins with 2 should return MasterCard', ->
      topic = Payment.fns.cardType '2221000010000015'
      assert.equal topic, 'mastercard'

    it 'that begins with 34 should return American Express', ->
      topic = Payment.fns.cardType '3412121212121212'
      assert.equal topic, 'amex'

    it 'that begins with 457393 should return Elo', ->
      topic = Payment.fns.cardType '4573931212121212'
      assert.equal topic, 'elo'

    it 'should not miscategorize cards with 5067 in them as elo', ->
      topic = Payment.fns.cardType '4012506712121212'
      assert.equal topic, 'visa'

    it 'should return hipercard type', ->
      assert.equal (Payment.fns.cardType '384100'), 'hipercard'
      assert.equal (Payment.fns.cardType '384140'), 'hipercard'
      assert.equal (Payment.fns.cardType '384160'), 'hipercard'
      assert.equal (Payment.fns.cardType '6062'), 'hipercard'
      assert.equal (Payment.fns.cardType '6012'), 'hipercard'

    it 'should not return hipercard type', ->
      topic = Payment.fns.cardType '6011'
      assert.equal topic, 'discover'

    it 'that is not numbers should return null', ->
      topic = Payment.fns.cardType 'aoeu'
      assert.equal topic, null

    it 'that has unrecognized beginning numbers should return null', ->
      topic = Payment.fns.cardType 'aoeu'
      assert.equal topic, null

  describe 'formatCardNumber', ->
    it 'should restrict non-number characters', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val number, '4242'

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "a".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4242'

    it 'should restrict characters after the length', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val number, '4242 4242 4242 4242 424'

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "4".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4242 4242 4242 4242 424'
    it 'should restrict characters when a generic card number is 16 characters', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '0000 0000 0000 0000')

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "0".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '0000 0000 0000 0000'
    it 'should restrict characters when a visa card number is greater than 19 characters', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4000 0000 0000 0000 030')

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "0".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4000 0000 0000 0000 030'

    it 'should restrict characters for visa when a `maxLength` parameter is set despite card length can be 19', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4242 4242 4242 4242')

      Payment.formatCardNumber(number, 16)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "0".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4242 4242 4242 4242'
    it 'should restrict characters correctly if `maxLength` exceeds max length for card', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '3472 486270 35790')

      Payment.formatCardNumber(number, 16)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "0".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '3472 486270 35790'
    it 'should format cc number correctly', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4242')

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "4".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4242 4'

    it 'should remove a trailing space before a number on backspace ', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4242 ')
      number.selectionStart = 5
      number.selectionEnd = 5

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keydown", true, true
      ev.eventName = "keydown"
      ev.which = 8

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '424'
    it 'should remove the space after a number being deleted on a backspace', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4242 5')
      number.selectionStart = 6
      number.selectionEnd = 6

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keydown", true, true
      ev.eventName = "keydown"
      ev.which = 8

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4242'
    it 'should set the card type correctly', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4')

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keyup", true, true
      ev.eventName = "keyup"
      number.dispatchEvent(ev)

      assert QJ.hasClass(number, 'visa')
      assert QJ.hasClass(number, 'identified')

      QJ.val(number, '')

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keyup", true, true
      ev.eventName = "keyup"
      number.dispatchEvent(ev)

      # JSDom doesn't support custom events right now, so this testing
      # doesn't work :(
      #
      # eventCalled = false
      # number.addEventListener 'payment.cardType', ->
      #   console.log 'hiya'
      #   eventCalled = true
      # assert eventCalled

      assert QJ.hasClass(number, 'unknown')
      assert !QJ.hasClass(number, 'identified')
    it 'should format correctly on paste', ->
      number = document.createElement('input')
      number.type = 'text'
      Payment.formatCardNumber(number)

      QJ.val(number, '42424')

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "paste", true, true
      ev.eventName = "paste"

      number.dispatchEvent(ev)

      # must setTimeout because paste event handling is
      # done in a setTimeout
      setTimeout ->
        assert.equal QJ.val(number), '4242 4'
    it 'should format cc number correctly when transitioning from one length limit to another', ->
      number = document.createElement('input')
      number.type = 'text'
      QJ.val(number, '4111 1111 1111 1111')

      Payment.formatCardNumber(number)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      number.dispatchEvent(ev)

      assert.equal QJ.val(number), '4111 1111 1111 1111 1'
  describe 'formatCardExpiry', ->
    it 'should add a slash after two numbers', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '1')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '11 / '
    it 'should format add a 0 and slash to a number > 1 correctly', ->
      expiry = document.createElement('input')
      expiry.type = "text"

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "4".charCodeAt(0)

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '04 / '
    it 'should format add a 0 to a number > 1 in the month input correctly', ->
      month = document.createElement('input')
      month.type = "text"
      year = document.createElement('input')
      year.type = "text"

      Payment.formatCardExpiry([month, year])

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "4".charCodeAt(0)

      month.dispatchEvent(ev)

      assert.equal QJ.val(month), '04'
    it 'should format forward slash shorthand correctly', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '1')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "/".charCodeAt(0)

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '01 / '

    it 'should only allow numbers', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '1')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "d".charCodeAt(0)

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '1'
    it 'should remove spaces trailing space and / after removing a number', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '12 / 1')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keydown", true, true
      ev.eventName = "keydown"
      ev.which = 8 # backspace

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '12'

    it 'should a number after removing a space and a /', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '12 / ')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keydown", true, true
      ev.eventName = "keydown"
      ev.which = 8 # backspace

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '1'
    it 'should restrict combined expiry fields to length <= 6 digits', ->
      expiry = document.createElement('input')
      expiry.type = "text"
      QJ.val(expiry, '12 / 2018')

      Payment.formatCardExpiry(expiry)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      expiry.dispatchEvent(ev)

      assert.equal QJ.val(expiry), '12 / 2018'
    it 'should restrict month expiry fields to length <= 2 digits', ->
      month = document.createElement('input')
      month.type = "text"
      QJ.val(month, '12')

      year = document.createElement('input')
      year.type = "text"
      QJ.val(year, '2018')

      Payment.formatCardExpiryMultiple(month, year)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      month.dispatchEvent(ev)

      assert.equal QJ.val(month), '12'
    it 'should restrict year expiry fields to length <= 4 digits', ->
      month = document.createElement('input')
      month.type = "text"
      QJ.val(month, '12')

      year = document.createElement('input')
      year.type = "text"
      QJ.val(year, '2018')

      Payment.formatCardExpiryMultiple(month, year)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      year.dispatchEvent(ev)

      assert.equal QJ.val(year), '2018'
  describe 'formatCVC', ->
    it 'should allow only numbers', ->
      cvc = document.createElement('input')
      cvc.type = "text"
      QJ.val(cvc, '1')

      Payment.formatCardCVC(cvc)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "d".charCodeAt(0)

      cvc.dispatchEvent(ev)

      assert.equal QJ.val(cvc), '1'
    it 'should restrict to length <= 4', ->
      cvc = document.createElement('input')
      cvc.type = "text"
      QJ.val(cvc, '1234')

      Payment.formatCardCVC(cvc)

      ev = document.createEvent "HTMLEvents"
      ev.initEvent "keypress", true, true
      ev.eventName = "keypress"
      ev.which = "1".charCodeAt(0)

      cvc.dispatchEvent(ev)

      assert.equal QJ.val(cvc), '1234'
