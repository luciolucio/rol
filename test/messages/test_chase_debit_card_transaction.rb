# -*- coding: UTF-8 -*-
# rubocop:disable LineLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the 'Your Debit Card Transaction' email from Chase
# TODO: Test creation at from_message
class TestChaseDebitCardTransaction < Test::Unit::TestCase
  # rubocop:disable SingleSpaceBeforeFirstArg
  def new_mail(body)
    Mail.new do
      from    'no-reply@alertsp.chase.com'
      to      'you@place.com'
      subject 'Your Debit Card Transaction'
      body    body
    end
  end
  # rubocop:enable SingleSpaceBeforeFirstArg

  def test_should_parse_debit_card_transaction
    message = new_mail('This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.')

    expected = { amount: 3.76, description: 'PIER 49 PIZZA - SALT', timestamp: '2013-12-24T19:13:48Z' }

    dct = ChaseDebitCardTransaction.from_message(message)
    assert_equal(expected, dct.to_expense)
  end

  def test_should_parse_debit_card_txn_with_trailing_spaces
    message = new_mail('This is an Alert to help manage your account ending in 6503.

      A $30.98 debit card transaction to STAPLES,INC          on 12/27/2013 7:30:07 PM EST exceeded your $0.00 set Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC.')

    expected = { amount: 30.98, description: 'STAPLES,INC', timestamp: '2013-12-28T00:30:07Z' }

    dct = ChaseDebitCardTransaction.from_message(message)
    assert_equal(expected, dct.to_expense)
  end
end
