# -*- coding: UTF-8 -*-

require_relative '../../lib/rol'
require 'test/unit'
require 'mail'

module Rol
  module Messages
    # A message from @one.com
    class OnesMessage
      def self.from_message(message)
        OnesMessage.new if message.sender.include? '@one.com'
      end
    end

    # A message from @three.com
    class ThreesMessage
      def self.from_message(message)
        ThreesMessage.new if message.sender.include? '@three.com'
      end
    end
  end
end

# Unit tests for Message
class TestMessage < Test::Unit::TestCase
  def setup
    Rol.config do
      message_types [
        Rol::Messages::OnesMessage,
        Rol::Messages::ThreesMessage
      ]
    end
  end

  def test_should_create_with_user
    user = Rol::User.new

    message = Mail.new do
      user user
    end

    assert_equal(user, message.user)
  end

  def test_should_identify_message_from_one_dot_com
    message = Mail.new { sender 'some@one.com' }
    message = message.identify
    assert(message.is_a?(Rol::Messages::OnesMessage))
  end

  def test_should_return_unrecognized_message_for_message_from_two_dot_com
    message = Mail.new { sender 'some@two.com' }
    message = message.identify
    assert(message.is_a?(Rol::Messages::UnrecognizedMessage))
  end

  def test_should_identify_message_from_three_dot_com
    message = Mail.new { sender 'some@three.com' }
    message = message.identify
    assert(message.is_a?(Rol::Messages::ThreesMessage))
  end
end
