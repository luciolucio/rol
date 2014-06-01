# -*- coding: UTF-8 -*-
# rubocop:disable LineLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the 'Your Debit Card Transaction' email from Chase
class TestChaseDebitCardTransaction < Test::Unit::TestCase
  def test_parse_debit_card_transaction
    # rubocop:disable SingleSpaceBeforeFirstArg
    message = Mail.new do
      from    'no-reply@alertsp.chase.com'
      to      'you@place.com'
      subject 'Your Debit Card Transaction'
      body    'This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.'
    end
    # rubocop:enable SingleSpaceBeforeFirstArg

    expected = { amount: 3.76, description: 'PIER 49 PIZZA - SALT', timestamp: '2013-12-24T19:13:48Z' }

    dct = ChaseDebitCardTransaction.from_message(message)
    assert_equal(expected, dct.to_expense)
  end
end
