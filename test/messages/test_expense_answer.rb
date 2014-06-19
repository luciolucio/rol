# -*- coding: UTF-8 -*-
# rubocop:disable ClassLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the answer to an expense from the user
class TestExpenseAnswer < Test::Unit::TestCase
  def setup
    Mail.defaults do
      delivery_method :test
    end

    Rol.config do
      storage :test
    end

    Mail::TestMailer.deliveries.clear
    Rol::Storage::TestStorage.stored_expenses.clear
  end

  def new_user
    @recipient = recipient = 'someone@example.com'

    Rol::User.new do
      recipient recipient
      format :plain_text
    end
  end

  def new_mail
    @expense = ex = save_an_expense
    user = new_user

    msg = Mail.new do
      from user.recipient
      user user
      message_id SecureRandom.uuid
    end

    msg.body = msg.user.format.format(ex)
    msg
  end

  def save_an_expense(output_id = 'myid', amount = 37)
    @output_id = output_id
    @amount = amount

    ex = Rol::Expense.new do
      amount amount
      input_message_id SecureRandom.uuid
      output_message_id output_id
    end

    ex.save
    ex
  end

  def test_should_create_if_from_user
    msg = new_mail

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    assert_equal(Rol::Messages::ExpenseAnswer, answer.class)
  end

  def test_should_not_create_if_from_someone_else
    msg = new_mail
    msg.from = 'another@person.com'

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    assert_equal(nil, answer)
  end

  def test_should_respond_if_replying_to_known_id
    msg = new_mail
    msg.in_reply_to @output_id

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    assert_equal(1, Mail::TestMailer.deliveries.size)
    assert_equal(msg.user.recipient, Mail::TestMailer.deliveries[0].to[0])
    # TODO: Test that it actually uses Reply
  end

  def test_should_not_respond_if_unknown_id
    msg = new_mail
    msg.in_reply_to 'some_other_id'

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    assert_equal(0, Mail::TestMailer.deliveries.size)
    # TODO: Test that it actually uses Reply
  end

  def test_should_change_amount_if_changed
    new_amount = 12.17

    msg = new_mail
    msg.in_reply_to @output_id
    msg.body = msg.body.decoded
               .gsub(/#{format('%.2f', @amount)}/, new_amount.to_s)

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    new_expense = Rol::Storage::TestStorage.stored_expenses[0]
    assert_equal(new_amount, new_expense.amount)
  end

  def test_should_not_change_amount_if_not_changed
    msg = new_mail
    msg.in_reply_to @output_id

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    expense_after = Rol::Storage::TestStorage.stored_expenses[0]
    assert_equal(@expense.amount, expense_after.amount)
  end

  def test_should_not_change_amout_of_a_different_expense
    save_an_expense('some_id', 84.11)

    msg = new_mail # saves another expense
    msg.in_reply_to @output_id

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    expenses_after = Rol::Storage::TestStorage.stored_expenses
    assert_equal(2, expenses_after.size)
    assert_equal(84.11, expenses_after[0].amount)
    assert_equal(@amount, expenses_after[1].amount)
  end

  def test_should_not_duplicate_if_processing_the_same_message_twice
    msg = new_mail
    msg.in_reply_to @output_id

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    answer = Rol::Messages::ExpenseAnswer.from_message(msg)
    answer.process

    assert_equal(1, Mail::TestMailer.deliveries.size)
    assert_equal(1, Rol::Storage::TestStorage.stored_expenses.size)
  end
end
