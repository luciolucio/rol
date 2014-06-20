# -*- coding: UTF-8 -*-
# rubocop:disable ClassLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the answer to an expense from the user
class TestExpenseAnswer < Test::Unit::TestCase
  attr_reader :mail_a

  USER = Rol::User.new do
    recipient 'someone@example.com'
    format :plain_text
  end

  EXPENSE_A = Rol::Expense.new do
    amount 37
    store_name 'hi'
    input_message_id SecureRandom.uuid
    output_message_id SecureRandom.uuid
  end

  EXPENSE_B = Rol::Expense.new do
    amount 84.11
    store_name 'ho'
    input_message_id SecureRandom.uuid
    output_message_id SecureRandom.uuid
  end

  def setup
    Mail.defaults do
      delivery_method :test
    end

    Rol.config do
      storage :test
    end

    Mail::TestMailer.deliveries.clear
    Rol::Storage::TestStorage.stored_expenses.clear
    @mail_a = create_mail_a
    EXPENSE_A.save
  end

  def create_mail_a
    Mail.new do
      from USER.recipient
      user USER
      body USER.format.format(EXPENSE_A)
      message_id SecureRandom.uuid
      in_reply_to EXPENSE_A.output_message_id
    end
  end

  def test_should_create_if_from_users_recipient
    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    assert_equal(Rol::Messages::ExpenseAnswer, answer.class)
  end

  def test_should_not_respond_if_unknown_id
    @mail_a.in_reply_to = 'some_other_id'

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    assert_equal(0, Mail::TestMailer.deliveries.size)
    # TODO: Test that it actually uses Reply
  end

  def test_should_respond_if_replying_to_known_id
    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    assert_equal(1, Mail::TestMailer.deliveries.size)
    assert_equal(
      mail_a.user.recipient,
      Mail::TestMailer.deliveries.last.to.first)
  end

  def test_should_change_amount_if_changed
    new_amount = 12.17

    mail_a.body = mail_a.body.decoded
               .gsub(/#{format('%.2f', EXPENSE_A.amount)}/, new_amount.to_s)

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    new_expense = Rol::Storage::TestStorage.stored_expenses.last
    assert_equal(new_amount, new_expense.amount)
  end

  def test_should_not_change_amount_if_not_changed
    answer = Rol::Messages::ExpenseAnswer.from_message(@mail_a)
    answer.process

    expense_after = Rol::Storage::TestStorage.stored_expenses.last
    assert_equal(EXPENSE_A.amount, expense_after.amount)
  end

  def test_should_change_store_name_if_changed
    new_store_name = 'Yoga Flame'

    mail_a.body = mail_a.body.decoded
               .gsub(/#{EXPENSE_A.store_name}/, new_store_name)

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    expense_after = Rol::Storage::TestStorage.stored_expenses.last

    assert_equal(new_store_name, expense_after.store_name)
  end

  def test_should_not_change_amout_of_a_different_expense
    new_amount = 11

    EXPENSE_B.save

    mail_a.body = mail_a.body.decoded
               .gsub(/#{format('%.2f', EXPENSE_A.amount)}/, new_amount.to_s)

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    expenses_after = Rol::Storage::TestStorage.stored_expenses
    assert_equal(2, expenses_after.size)
    assert_equal(new_amount, expenses_after[0].amount)
    assert_equal(EXPENSE_B.amount, expenses_after[1].amount)
  end

  def test_should_not_duplicate_if_processing_the_same_message_twice
    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    answer.process

    assert_equal(1, Mail::TestMailer.deliveries.size)
    assert_equal(1, Rol::Storage::TestStorage.stored_expenses.size)
  end

  def test_should_not_create_if_from_someone_else
    mail_a.from = 'another@person.com'

    answer = Rol::Messages::ExpenseAnswer.from_message(mail_a)
    assert_equal(nil, answer)
  end
end
