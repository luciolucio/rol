# -*- coding: UTF-8 -*-

# Tests the plain text formatter
class TestPlainText < Test::Unit::TestCase
  PLAIN_TEXT = {
    simple: {
      expense: Rol::Expense.new do
                 amount 11.14
                 description 'Delicious Food Inc.'
                 timestamp '2019-11-11T23:40:11Z'
               end,
      format: "Amount: 11.14\n" \
              "Description: Delicious Food Inc.\n" \
              'Timestamp: 2019-11-11T23:40:11Z'
    },
    round: {
      expense: Rol::Expense.new do
                 amount 5.00
                 description 'Five moneys'
                 timestamp '2015-11-11T11:11:11Z'
               end,
      format: "Amount: 5.00\n" \
              "Description: Five moneys\n" \
              'Timestamp: 2015-11-11T11:11:11Z'
    }
  }

  def test_should_format_simple_expense
    ex = PLAIN_TEXT[:simple][:expense]
    format = Rol::Format::PlainText.new
    assert_equal(PLAIN_TEXT[:simple][:format], format.format(ex))
  end

  def test_should_format_round_amount
    ex = PLAIN_TEXT[:round][:expense]
    format = Rol::Format::PlainText.new
    assert_equal(PLAIN_TEXT[:round][:format], format.format(ex))
  end

  def test_should_parse_simple_expense
    formatted = PLAIN_TEXT[:simple][:format]
    format = Rol::Format::PlainText.new
    assert_equal(PLAIN_TEXT[:simple][:expense], format.parse(formatted))
  end

  def test_should_parse_round_expense
    formatted = PLAIN_TEXT[:round][:format]
    format = Rol::Format::PlainText.new
    assert_equal(PLAIN_TEXT[:round][:expense], format.parse(formatted))
  end
end
