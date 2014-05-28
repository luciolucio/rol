# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'test/unit'
require 'mail'

module Rol
  module Message
    # For testing - a message that is from @one.com
    class OnesMessage
      def initialize(message)
        @message = message
      end

      def method_missing?(method, *args, &block)
        @message.send(method, *args, &block)
      end

      def self.from_message(message)
        if message.sender.include? '@one.com'
          OnesMessage.new(message)
        else
          nil
        end
      end
    end
  end
end

# Unit tests for Message
class TestMessage < Test::Unit::TestCase
  def test_categorize
    message = Mail.new { sender 'some@one.com' }
    message = message.categorize
    assert(message.is_a?(Rol::Message::OnesMessage))
  end
end
