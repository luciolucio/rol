# -*- coding: UTF-8 -*-

require 'test/unit'
require_relative '../lib/rol'

# Unit tests for parsing functionality,
# including parsing emails and any
# other format that we're able to parse

class TestParse < Test::Unit::TestCase
  def test_parse
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.",
      amount: 3.76, description: 'PIER 49 PIZZA - SALT')
  end

  def test_parse_with_trailing_spaces
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $30.98 debit card transaction to STAPLES,INC          on 12/27/2013 7:30:07 PM EST exceeded your $0.00 set Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC.",
      amount: 30.98, description: 'STAPLES,INC')
  end

  def test_withdrawal
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $80.00 ATM withdrawal on 12/27/2013 4:13:32 PM EST exceeded your $0.00 Alert limit.

      If you have any questions about this transaction, please call 1-877-CHASEPC",
      amount: 80.00, description: 'ATM Withdrawal')
  end

  def test_external_transfer
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A $54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.

      If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
      amount: 54.47, description: 'ROCKYMTN/PACIFIC POW')
  end

  def test_bad_format
    run_parse_test_with(
      "This is an Alert to help manage your account ending in 6503.

      A 54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.

      If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).",
      amount: 0, description: '')
  end

  private

  def run_parse_test_with(message, expected)
    parser = Rol::Parser.new
    assert_equal(expected, parser.parse(message))
  end
end
