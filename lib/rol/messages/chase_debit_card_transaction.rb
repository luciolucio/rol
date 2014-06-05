# -*- coding: UTF-8 -*-
require 'american_date'
require 'time'

module Rol
  module Messages
    # 'Your Debit Card Transaction' email from Chase
    # TODO: Other emails with these expressions:
    # /A \$(.*) external transfer to (.*) on (.*) exceeded/,
    # /A \$(.*) (ATM withdrawal) on (.*) exceeded/
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

        Expense.new do
          amount matches[1].to_f
          description matches[2].strip
          timestamp DateTime.parse(matches[3]).to_time.utc.iso8601
        end
      end

      def process
        ex = to_expense
        Rol.storage.save_expense(ex)

        Mail.deliver do
          to 'someone@example.com'
          from 'person@example.com'
          subject 'Hi there'
          body "Amount: #{ex.amount}\n" \
               "Description: #{ex.description}\n" \
               "Timestamp: #{ex.timestamp}"
        end
      end

      private

      def initialize(message)
        @body = message.body.decoded
      end
    end
  end
end
