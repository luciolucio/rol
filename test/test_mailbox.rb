# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'
require 'rr'

# Unit tests for Mailbox

class TestMailbox < Test::Unit::TestCase
  def setup
    @connection = Rol::MailConnection.new('', '')
    stub(@connection).connect
    @mailbox = Rol::Mailbox.new(@connection)
  end

  def test_initialize_should_connect
    assert_nothing_raised do
      @connection = Rol::MailConnection.new('', '')
      assert_equal(true, @mailbox.connected?)
    end
  end

  def test_throw_if_cannot_connect
    stub(@connection).connect { fail Rol::InvalidUsernameOrPasswordError }

    assert_raise Rol::InvalidUsernameOrPasswordError do
      Rol::Mailbox.new(@connection)
    end
  end

  def test_get_messages_from_connection
    messages = [Rol::MailMessage.new]
    stub(@connection).get_messages { messages }

    assert_equal(messages, @mailbox.get_messages)
  end
end
