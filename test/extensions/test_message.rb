# -*- coding: UTF-8 -*-

require_relative '../../lib/rol'
require 'test/unit'
require 'mail'

module Rol
  module Message
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
        Rol::Message::OnesMessage,
        Rol::Message::ThreesMessage
      ]
    end
  end

  def test_should_categorize_message_from_one_dot_com
    message = Mail.new { sender 'some@one.com' }
    message = message.categorize
    assert(message.is_a?(Rol::Message::OnesMessage))
  end

  def test_should_return_null_for_message_from_two_dot_com
    message = Mail.new { sender 'some@two.com' }
    message = message.categorize
    assert(message.nil?)
  end

  def test_should_categorize_message_from_three_dot_com
    message = Mail.new { sender 'some@three.com' }
    message = message.categorize
    assert(message.is_a?(Rol::Message::ThreesMessage))
  end
end
