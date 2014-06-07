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
      attr_accessor :body
      attr_accessor :user

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
        deliver(ex, @user.recipient)
      end

      private

      def initialize(message)
        @body = message.body.decoded
        @user = message.user
      end

      def deliver(expense, recipient)
        Mail.deliver do
          to recipient
          from 'person@example.com'
          subject 'Hi there'
          body "Amount: #{expense.amount}\n" \
               "Description: #{expense.description}\n" \
               "Timestamp: #{expense.timestamp}"
        end
      end
    end
  end
end
