module Rol
  # Base module for incoming expense messages
  module ExpenseMessage
    def process
      expense = Expense.find(input_message_id: @message.message_id)
      return unless expense.nil?

      new_expense = to_expense

      deliver(new_expense, @message.user.recipient)
      new_expense.save
    end

    private

    def initialize(message)
      @message = message
    end

    def deliver(expense, recipient)
      format = @message.user.format
      method = @message.user.delivery_method
      settings = @message.user.delivery_settings

      msg = create_message(expense, recipient, format, method, settings)
      msg.deliver!

      expense.output_message_id = msg.message_id
    end

    def create_message(expense, recipient, format, method, settings)
      Mail.new do
        to recipient
        from 'person@example.com'
        subject 'Hi there'
        text_part do
          body format.format(expense)
        end
        delivery_method method, settings
      end
    end
  end
end
