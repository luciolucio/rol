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

  def test_should_create_with_no_parameters
    e = Rol::Expense.new

    assert_equal(nil, e.amount)
    assert_equal(nil, e.description)
    assert_equal(nil, e.timestamp)
  end

  def test_should_save_using_storage
    Rol.config do
      storage :test
    end

    e = Rol::Expense.new
    e.save

    assert_equal(true, Rol::Storage::TestStorage.stored_expenses.include?(e))
  end
end
