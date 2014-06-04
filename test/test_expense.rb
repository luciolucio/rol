# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'

# Test Expense
class TestExpense < Test::Unit::TestCase
  def test_should_create_with_parameters_in_constructor
    e = Rol::Expense.new do
      amount 10
      description 'Hi'
      timestamp '10:15'
    end

    assert_equal(10, e.amount)
    assert_equal('Hi', e.description)
    assert_equal('10:15', e.timestamp)
  end
end
