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
      include Rol::ExpenseMessage
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
        message_id = @message.message_id
        expr = /A \$(.*) debit card transaction to (.*) on (.*) exceeded/
        matches = expr.match(@message.body.decoded)

        Expense.new do
          amount matches[1].to_f
          merchant_name matches[2].strip
          description 'A Chase Debit Card Transaction'
          timestamp DateTime.parse(matches[3]).to_time.utc.iso8601
          input_message_id message_id
        end
      end
    end
  end
end
