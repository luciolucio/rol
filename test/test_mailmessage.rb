# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'

# Unit tests for the MailMessage
class TestMailMessage < Test::Unit::TestCase
  def test_can_create_message_without_body
    message = Rol::MailMessage.new(1)
    assert_equal('', message.body)
  end

  def test_can_set_body
    message = Rol::MailMessage.new(1)
    message.body = 'This is its body'
    assert_equal('This is its body', message.body)
  end

  def test_cannot_set_id
    assert_raise NoMethodError do
      message = Rol::MailMessage.new(2)
      message.id = 3
    end
  end

  def test_message_gets_created_with_id
    message = Rol::MailMessage.new(2)
    assert_equal(2, message.id)
  end

  def test_can_create_message_with_body
    body = 'This is its body'
    message = Rol::MailMessage.new(1, body)
    assert_equal('This is its body', message.body)
  end
end
