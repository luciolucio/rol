# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'

# Unit tests for MailMessage

class TestMailbox < Test::Unit::TestCase
  def test_can_create_message_without_body
    message = Rol::MailMessage.new
    assert_equal('', message.body)
  end

  def test_can_set_body
    message = Rol::MailMessage.new
    message.body = 'This is its body'
    assert_equal('This is its body', message.body)
  end

  def test_can_create_message_with_body
    body = 'This is its body'
    message = Rol::MailMessage.new(body)
    assert_equal('This is its body', message.body)
  end
end
