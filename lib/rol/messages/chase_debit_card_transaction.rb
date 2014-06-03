# -*- coding: UTF-8 -*-

module Rol
  module Messages
    # 'Your Debit Card Transaction' email from Chase
    class ChaseDebitCardTransaction
      def self.from_message(message)
        if message.subject.include?('Your Debit Card Transaction') &&
           message.from[0].include?('chase.com')
          return ChaseDebitCardTransaction.new(message)
        end

        nil
      end

      def to_expense
        expr = /A \$(.*) debit card transaction to (.*) on (.*) exceeded/
        matches = expr.match(@body)
        amount = matches[1].to_f
        description = matches[2].strip
        timestamp = DateTime.parse(matches[3]).to_time.utc.iso8601

        { amount: amount, description: description, timestamp: timestamp }
      end

      private

      def initialize(message)
        @body = message.body.decoded
      end
    end
  end
end
