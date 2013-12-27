module Rol
  class Parser
    def parse (message)
      results = /A \$(.*) debit card transaction to (.*) on/.match(message)

      { :amount => results[1].to_f, :description => results[2] }
    end
  end
end
