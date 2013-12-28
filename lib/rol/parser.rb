module Rol
  class Parser
    @@nil_result = { :amount => 0, :description => '' }

    def parse (message)
      results = /A \$(.*) (debit card transaction to (.*)|ATM withdrawal) on/.match(message)

      if results.nil? then
        results = /A \$(.*) (external transfer to (.*)|ATM withdrawal) on/.match(message)
      end

      return @@nil_result if results.nil? || results.size < 3

      amount = results[1].to_f
      description = results[2] == 'ATM withdrawal' ? 'ATM Withdrawal' : results[3].strip

      { :amount => amount, :description => description }
    end
  end
end
