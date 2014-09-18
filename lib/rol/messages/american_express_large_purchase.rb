# -*- coding: UTF-8 -*-
require 'american_date'
require 'time'

module Rol
  module Messages
    # 'Account Alert: Large Purchase' email from American Express
    class AmericanExpressLargePurchase
      include Rol::ExpenseMessage
      attr_accessor :body
      attr_accessor :user

      def self.from_message(message)
        if message.subject.include?('Account Alert: Large Purchase') &&
           message.from[0].include?('aexp.com')
          return AmericanExpressLargePurchase.new(message)
        end

        nil
      end

      def to_expense
        message_id = @message.message_id
        expr = build_expression
        matches = expr.match(@message.body.decoded)

        Expense.new do
          amount matches[3].to_f
          merchant_name matches[2].strip
          description 'An American Express Purchase'
          timestamp DateTime.parse(matches[1]).to_time.utc.iso8601
          input_message_id message_id
        end
      end

      def build_expression
        regex = '<b>Transaction Date:</b>.*?<b>(.*?)</b>.*' \
        '<b>Merchant Name:</b>.*?<b>(.*?)</b>.*' \
        '<b>Purchase Amount:</b>.*?<b>\$(.*?)</b>'

        /#{regex}/m
      end
    end
  end
end
