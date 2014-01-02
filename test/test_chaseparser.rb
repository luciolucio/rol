# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'

# Unit tests for parsing functionality,
# including parsing emails and any
# other format that we're able to parse

# rubocop:disable LineLength
class TestChaseParser < Test::Unit::TestCase
  def test_parse_debit_card_transaction
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.",
      amount: 3.76, description: 'PIER 49 PIZZA - SALT', timestamp: '2013-12-24T19:13:48Z')
  end

  def test_parse_debit_card_with_trailing_spaces
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $30.98 debit card transaction to STAPLES,INC          on 12/27/2013 7:30:07 PM EST exceeded your $0.00 set Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC.",
      amount: 30.98, description: 'STAPLES,INC', timestamp: '2013-12-28T00:30:07Z')
  end

  def test_parse_atm_withdrawal
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $80.00 ATM withdrawal on 12/27/2013 4:13:32 PM EST exceeded your $0.00 Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC",
      amount: 80.00, description: 'ATM withdrawal', timestamp: '2013-12-27T21:13:32Z')
  end

  def test_parse_external_transfer
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.

      If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
      amount: 54.47, description: 'ROCKYMTN/PACIFIC POW', timestamp: '2013-12-27T07:05:13Z')
  end

  def test_bad_format
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A 54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.

      If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
      amount: 0, description: '', timestamp: '')
  end

  private

  def run_parse_test_with(message, expected)
    parser = Rol::ChaseParser.new
    assert_equal(expected, parser.parse(message))
  end
end
