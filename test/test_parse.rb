require "test/unit"
require_relative "../lib/rol/parser"

class TestParse < Test::Unit::TestCase
  def test_parse
    message = <<MSG
This is an Alert to help manage your account ending in 6503.

A $3.76 debit card transaction to PIER 49 PIZZA - SALT on 12/24/2013 2:13:48 PM EST exceeded your $0.00 set Alert limit.
MSG

    parser = Rol::Parser.new

    expected = {
      :amount => 3.76,
      :description => "PIER 49 PIZZA - SALT",
    }

    assert_equal(expected, parser.parse(message))
  end

  def test_parse_with_trailing_spaces
    message = <<MSG
This is an Alert to help manage your account ending in 6503.

A $30.98 debit card transaction to STAPLES,INC          on 12/27/2013 7:30:07 PM EST exceeded your $0.00 set Alert limit.

If you have any questions about this transaction, please call 1-877-CHASEPC.
MSG

    parser = Rol::Parser.new

    expected = {
      :amount => 30.98,
      :description => "STAPLES,INC",
    }

    assert_equal(expected, parser.parse(message))
  end

  def test_withdrawal
    message = <<MSG
This is an Alert to help manage your account ending in 6503.

A $80.00 ATM withdrawal on 12/27/2013 4:13:32 PM EST exceeded your $0.00 Alert limit.

If you have any questions about this transaction, please call 1-877-CHASEPC
MSG

    parser = Rol::Parser.new

    expected = {
      :amount => 80.00,
      :description => "ATM Withdrawal",
    }

    assert_equal(expected, parser.parse(message))
  end

  def test_external_transfer
    message = <<MSG
This is an Alert to help manage your account ending in 6503.

A $54.47 external transfer to ROCKYMTN/PACIFIC POW on 12/27/2013 2:05:13 AM EST exceeded your Alert setting.

If you have questions about this transaction, please log on to chase.com or call 1-877-CHASEPC (1-877-242-7372).
MSG

    parser = Rol::Parser.new

    expected = {
      :amount => 54.47,
      :description => "ROCKYMTN/PACIFIC POW",
    }

    assert_equal(expected, parser.parse(message))
  end
end
