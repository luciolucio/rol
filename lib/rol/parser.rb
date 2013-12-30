# -*- coding: UTF-8 -*-

module Rol
  # Parse messages in plain text and return a hash with
  # parsed values such as quantity and description

  class Parser
    @nil_result = { amount: 0, description: '' }

    def parse(message)
      results = /A \$(.*) (debit card transaction to (.*)|ATM withdrawal) on/.match(message)

      if results.nil?
        results = /A \$(.*) (external transfer to (.*)|ATM withdrawal) on/.match(message)
      end

      return @nil_result if results.nil?

      amount = results[1].to_f
      description = results[2] == 'ATM withdrawal' ? 'ATM Withdrawal' : results[3].strip

      { amount: amount, description: description }
    end
  end
end
