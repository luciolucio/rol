require "test/unit"
require_relative "../lib/rol/parser"

class TestParse < Test::Unit::TestCase
  def test_parse
    message = <<-MSG
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
end
