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
        expenses = Rol.storage.all
        output_ids = expenses.map { |e| e.output_message_id }
        return unless output_ids.include? @message.in_reply_to

        new_expense = @message.user.format.parse(@message.body.decoded)
        update_expense(expenses, new_expense)

        Rol.storage.save_all_expenses(expenses)

        deliver(@message.user.recipient)
      end

      private

      def initialize(message)
        @message = message
      end

      def update_expense(expenses, new_expense)
        expenses.each do |ex|
          next unless ex.output_message_id == @message.in_reply_to

          ex.amount = new_expense.amount
        end
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
