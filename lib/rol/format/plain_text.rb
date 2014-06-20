# -*- coding: UTF-8 -*-

module Rol
  module Format
    # Formats expenses as plain text
    class PlainText
      def format(e)
        Kernel.format("Amount: %.2f\nStore Name: %s\n" \
                      "Description: %s\nTimestamp: %s",
                      e.amount, e.store_name, e.description, e.timestamp)
      end

      def parse(text)
        expr_line_1 = /.*Amount: (.*)\n.*Store Name: (.*)\n/
        expr_line_2 = /.*Description: (.*)\n.*Timestamp: (.*)/

        matches = /#{expr_line_1}#{expr_line_2}/.match(text)

        Rol::Expense.new do
          amount matches[1].to_f
          store_name matches[2]
          description matches[3]
          timestamp matches[4]
        end
      end
    end
  end
end
