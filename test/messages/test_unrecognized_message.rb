# -*- coding: UTF-8 -*-
# rubocop:disable LineLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the UnrecognizedMessage (kind of like Null Object)
class TestUnrecognizedMessage < Test::Unit::TestCase
  def test_should_parse_to_a_zero_expense
    unrec = Rol::Messages::UnrecognizedMessage.new
    expense = unrec.to_expense

    assert_equal(nil, expense.amount)
    assert_equal(nil, expense.description)
    assert_equal(nil, expense.timestamp)
  end
end
