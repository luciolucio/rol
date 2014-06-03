# -*- coding: UTF-8 -*-

module Rol
  module Messages
    # A message that does not match any of the other parsers
    class UnrecognizedMessage
      def to_expense
        { amount: 0 }
      end
    end
  end
end
