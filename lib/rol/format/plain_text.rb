# -*- coding: UTF-8 -*-

module Rol
  module Format
    # Formats expenses as plain text
    class PlainText
      def format(e)
        Kernel.format("Amount: %.2f\nStore Name: %s\nTimestamp: %s",
                      e.amount, e.store_name, e.timestamp)
      end

      def parse(text)
        expr = /Amount: (.*)\nStore Name: (.*)\nTimestamp: (.*)/
        matches = expr.match(text)

        Rol::Expense.new do
          amount matches[1].to_f
          store_name matches[2]
          timestamp matches[3]
        end
      end
    end
  end
end
