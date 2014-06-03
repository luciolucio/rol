# -*- coding: UTF-8 -*-
# rubocop:disable LineLength

require_relative '../../lib/rol'
require 'test/unit'

# Test the UnrecognizedMessage (kind of like Null Object)
class TestUnrecognizedMessage < Test::Unit::TestCase
  def test_should_parse_to_a_zero_expense
    unrec = Rol::Messages::UnrecognizedMessage.new
    assert_equal({ amount: 0 }, unrec.to_expense)
  end
end
