# -*- coding: UTF-8 -*-
# rubocop:disable LineLength

# TODO: Test other types of messages
#
#      1. ATM withdrawal
#      "This is an Alert to help manage your account ending in 6503.
#
#      A $80.00 ATM withdrawal on 12/27/2013 4:13:32 PM EST exceeded your $0.00 Alert limit.
#
#      If you have any questions about this transaction, please call 1-877-CHASEPC",
#      amount: 80.00, description: 'ATM withdrawal', timestamp: '2013-12-27T21:13:32Z')
#
#
#     2. External transfer
#     "This is an Alert to help manage your account ending in 6503.
#
#     A $54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.
#
#     If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
#     amount: 54.47, description: 'ROCKYMTN/PACIFIC POW', timestamp: '2013-12-27T07:05:13Z')
#
#
#     3. Bad format (look ma, no dollar sign!)
#     "This is an Alert to help manage your account ending in 6503.
#
#     A 54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.
#
#     If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
#     amount: 0, description: '', timestamp: '')

require_relative '../../lib/rol'
require 'test/unit'

# Test the 'Your Debit Card Transaction' email from Chase
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

  def setup
    Rol.config do
      storage :test
    end
  end

  def test_should_parse_debit_card_transaction
    message = new_mail('This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.')

    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(message)
    expense = dct.to_expense

    assert_equal(3.76, expense.amount)
    assert_equal('PIER 49 PIZZA - SALT', expense.description)
    assert_equal('2013-12-24T19:13:48Z', expense.timestamp)
  end

  def test_should_parse_debit_card_txn_with_trailing_spaces
    message = new_mail('This is an Alert to help manage your account ending in 6503.

      A $30.98 debit card transaction to STAPLES,INC          on 12/27/2013 7:30:07 PM EST exceeded your $0.00 set Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC.')

    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(message)
    expense = dct.to_expense

    assert_equal(30.98, expense.amount)
    assert_equal('STAPLES,INC', expense.description)
    assert_equal('2013-12-28T00:30:07Z', expense.timestamp)
  end

  def test_should_create_when_subject_and_sender_are_right
    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(new_mail(''))
    assert_equal(Rol::Messages::ChaseDebitCardTransaction, dct.class)
  end

  def test_should_return_null_when_subject_is_not_right
    mail = new_mail('')
    mail.subject = 'Something else'
    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(mail)
    assert_equal(nil, dct)
  end

  def test_should_return_null_when_sender_is_not_right
    mail = new_mail('')
    mail.from = 'person@otherbank.com'
    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(mail)
    assert_equal(nil, dct)
  end

  def test_process_will_parse_and_save
    message = new_mail('This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.')
    dct = Rol::Messages::ChaseDebitCardTransaction.from_message(message)
    dct.process

    saved_expense = Rol::Storage::TestStorage.stored_expenses.first

    assert_equal(3.76, saved_expense.amount)
    assert_equal('PIER 49 PIZZA - SALT', saved_expense.description)
    assert_equal('2013-12-24T19:13:48Z', saved_expense.timestamp)
  end
end
