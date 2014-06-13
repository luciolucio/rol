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

  def test_should_create_with_parameters_in_constructor_more
    e = Rol::Expense.new do
      input_message_id 'myid'
      output_message_id 'myoid'
    end

    assert_equal('myid', e.input_message_id)
    assert_equal('myoid', e.output_message_id)
  end

  def test_should_create_with_no_parameters
    e = Rol::Expense.new

    assert_equal(nil, e.amount)
    assert_equal(nil, e.description)
    assert_equal(nil, e.timestamp)
    assert_equal(nil, e.input_message_id)
    assert_equal(nil, e.output_message_id)
  end

  def test_should_save_using_storage
    Rol.config do
      storage :test
    end

    e = Rol::Expense.new
    e.save

    assert_equal(true, Rol::Storage::TestStorage.stored_expenses.include?(e))
  end

  def test_should_be_equal_if_equal_attributes
    ex = Rol::Expense.new do
      amount 2
      description 'Yo'
      timestamp '1:13'
      input_message_id 'id'
      output_message_id 'oid'
    end

    assert_equal(ex.dup, ex)
  end

  def test_should_not_be_equal_if_attributes_differ
    ex = Rol::Expense.new do
      amount 2
      description 'Yo'
      timestamp '1:13'
      input_message_id 'id'
      output_message_id 'oid'
    end

    ex2 = ex.dup
    ex2.amount = 5
    # TODO: Test for other attributes being different too

    assert_not_equal(ex2, ex)
  end

  def test_should_be_equal_if_all_attributes_nil
    ex = Rol::Expense.new do
      amount nil
      description nil
      timestamp nil
      input_message_id nil
      output_message_id nil
    end

    assert_equal(ex.dup, ex)
  end
end
