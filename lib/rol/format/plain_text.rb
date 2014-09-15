# -*- coding: UTF-8 -*-

module Rol
  module Format
    # Formats expenses as plain text
    class PlainText
      line_1 = /.*Amount: (.*)\n.*Store Name: (.*)\n/
      line_2 = /.*Description: (.*)\n.*Tags: (.*)\n/
      line_3 = /.*Timestamp: (.*)/

      EXPRESSION = /#{line_1}#{line_2}#{line_3}/

      def format(e)
        Kernel.format("Amount: %.2f\nStore Name: %s\n" \
                      "Description: %s\nTags: %s\nTimestamp: %s",
                      e.amount, e.store_name, e.description,
                      e.tags.join(' '), e.timestamp)
      end

      def parse(text)
        matches = EXPRESSION.match(text)

        Rol::Expense.new do
          amount matches[1].to_f
          store_name matches[2]
          description matches[3]
          tags matches[4].split
          timestamp matches[5]
        end
      end
    end
  end
end
