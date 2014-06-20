# -*- coding: UTF-8 -*-

module Rol
  module Messages
    # The answer to an expense, such as a message
    # to give an expense a new description
    class ExpenseAnswer
      def self.from_message(message)
        if message.from[0] == message.user.recipient
          return ExpenseAnswer.new(message)
        end

        nil
      end

      def process
        expense = Expense.find(output_message_id: @message.in_reply_to)
        return if expense.nil?
        return if expense.answer_ids.include?(@message.message_id)

        expense.answer_ids << @message.message_id

        new_expense = @message.user.format.parse(@message.body.decoded)
        expense.amount = new_expense.amount
        expense.description = new_expense.description

        expense.save

        deliver(@message.user.recipient)
      end

      private

      def initialize(message)
        @message = message
      end

      def deliver(recipient)
        Mail.deliver do
          from 'yoga@fire.biz'
          to recipient
          subject 'Hi'
          body 'ok'
        end
      end
    end
  end
end
