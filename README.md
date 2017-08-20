# Payment [![Build Status](https://travis-ci.org/jessepollak/payment.svg?branch=master)](https://travis-ci.org/jessepollak/payment)

A jQuery-free general purpose library for building credit card forms, validating inputs and formatting numbers. Heavily, heavily based on [@stripe's jquery.payment library](http://github.com/stripe/jquery.payment), but without the jQuery.

For example, you can make a input act like a credit card field (with number formatting and length restriction):

``` javascript
Payment.formatCardNumber(document.querySelector('input.cc-num'));
```

Then, when the payment form is submitted, you can validate the card number on the client-side:

``` javascript
var valid = Payment.fns.validateCardNumber(document.querySelector('input.cc-num').value);

if (!valid) {
  alert('Your card is not valid!');
  return false;
}
```

You can find a full [demo here](http://jessepollak.github.io/payment/example).

Supported card types are:

* Visa
* MasterCard
* American Express
* Discover
* JCB
* Diners Club
* Maestro
* Laser
* UnionPay
* Elo
* Hipercard

## API

### Payment.formatCardNumber(element[, maxLength])
Formats card numbers:

* Includes a space between every 4 digits
* Restricts input to numbers
* Limits to 16 numbers
* Supports American Express formatting
* Adds a class of the card type (e.g. 'visa') to the input
* If second parameter is specified then card length will be limited to its value (19 digits cards are not in use despite being included in specifications)

Example:

``` javascript
Payment.formatCardNumber(document.querySelector('input.cc-num'));
```

### Payment.formatCardExpiry(element)

Formats card expiry:

* Includes a `/` between the month and year
* Restricts input to numbers
* Restricts length

Example:

``` javascript
Payment.formatCardExpiry(document.querySelector('input.cc-exp'));
```

### Payment.formatCardCVC(element)
Formats card CVC:

* Restricts length to 4 numbers
* Restricts input to numbers

Example:

``` javascript
Payment.formatCardCVC(document.querySelector('input.cc-cvc'));
```

### Payment.restrictNumeric(element)

General numeric input restriction.

Example:

``` javascript
Payment.restrictNumeric(document.querySelector('[data-numeric]'));
```

### Payment.fns.validateCardNumber(number)

Validates a card number:

* Validates numbers
* Validates Luhn algorithm
* Validates length

Example:

``` javascript
Payment.fns.validateCardNumber('4242 4242 4242 4242'); //=> true
```

### Payment.fns.validateCardExpiry(month, year), Payment.fns.validateCardExpiry('month / year')

Validates a card expiry:

* Validates numbers
* Validates in the future
* Supports year shorthand
* Supports formatted as `formatCardExpiry` input value

Example:

``` javascript
Payment.fns.validateCardExpiry('05', '20'); //=> true
Payment.fns.validateCardExpiry('05', '2015'); //=> true
Payment.fns.validateCardExpiry('05', '05'); //=> false
Payment.fns.validateCardExpiry('05 / 25'); //=> true
Payment.fns.validateCardExpiry('05 / 2015'); //=> false
```

### Payment.fns.validateCardCVC(cvc, type)

Validates a card CVC:

* Validates number
* Validates length to 4

Example:

``` javascript
Payment.fns.validateCardCVC('123'); //=> true
Payment.fns.validateCardCVC('123', 'amex'); //=> true
Payment.fns.validateCardCVC('1234', 'amex'); //=> true
Payment.fns.validateCardCVC('12344'); //=> false
```

### Payment.fns.cardType(number)

Returns a card type. Either:

* `visa`
* `mastercard`
* `discover`
* `amex`
* `jcb`
* `dinersclub`
* `maestro`
* `laser`
* `unionpay`
* `elo`
* `hipercard`

The function will return `null` if the card type can't be determined.

Example:

``` javascript
Payment.fns.cardType('4242 4242 4242 4242'); //=> 'visa'
```

### Payment.fns.cardExpiryVal(string) and Payment.cardExpiryVal(el)

Parses a credit card expiry in the form of MM/YYYY, returning an object containing the `month` and `year`. Shorthand years, such as `13` are also supported (and converted into the longhand, e.g. `2013`).

``` javascript
Payment.fns.cardExpiryVal('03 / 2025'); //=> {month: 3: year: 2025}
Payment.fns.cardExpiryVal('05 / 04'); //=> {month: 5, year: 2004}
Payment.fns.cardExpiryVal(document.querySelector('input.cc-exp')) //=> {month: 4, year: 2020}
```

This function doesn't perform any validation of the month or year; use `Payment.fns.validateCardExpiry(month, year)` for that.

## Card Type functions

We've provided utility functions to change which card types can be identified by Payment.

### Payment.getCardArray()

Returns the array of card types.

### Payment.setCardArray(cardTypes)

Overrides the array of card types with a new array.

### Payment.addToCardArray(cardType)

Add a new card type to the card array.

### Payment.removeFromCardArray(cardName)

Remove a card type from the card array.

## Example

Look in [`./example/index.html`](example/index.html)

## Building

Run `gulp build`

## Running tests

Run `gulp test`

## Autocomplete recommendations

We recommend you turn autocomplete on for credit card forms, except for the CVC field. You can do this by setting the `autocomplete` attribute:

``` html
<form autocomplete="on">
  <input class="cc-number">
  <input class="cc-cvc" autocomplete="off">
</form>
```

You should also mark up your fields using the [Autofill spec](https://html.spec.whatwg.org/multipage/forms.html#autofill). These are respected by a number of browsers, including Chrome.

``` html
<input type="text" class="cc-number" pattern="\d*" autocompletetype="cc-number" placeholder="Card number" required>
```

Set `autocompletetype` to `cc-number` for credit card numbers, `cc-exp` for credit card expiry and `cc-csc` for the CVC (security code).

## Mobile recommendations

We recommend you set the `pattern` attribute which will cause the numeric keyboard to be displayed on mobiles:

``` html
<input class="cc-number" pattern="\d*">
```

You may have to turn off HTML5 validation (using the `novalidate` form attribute) when using this `pattern`, as it won't match space formatting.
