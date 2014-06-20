# -*- coding: UTF-8 -*-

module Rol
  module Messages
    # A message that does not match any of the other parsers
    class UnrecognizedMessage
      def to_expense
        Expense.new do
          amount nil
          store_name nil
          timestamp nil
        end
      end

      def process
      end
    end
  end
end
