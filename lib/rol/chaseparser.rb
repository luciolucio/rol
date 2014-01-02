# -*- coding: UTF-8 -*-
require 'american_date'
require 'time'

module Rol
  # Parse Chase messages in plain text and return a hash with
  # parsed values such as quantity and description

  class ChaseParser
    NIL_RESULT = { amount: 0, description: '', timestamp: '' }
    EXPRESSIONS = [
        /A \$(.*) debit card transaction to (.*) on (.*) exceeded/,
        /A \$(.*) external transfer to (.*) on (.*) exceeded/,
        /A \$(.*) (ATM withdrawal) on (.*) exceeded/,
    ]

    def parse(message)
      EXPRESSIONS.each do |e|
        matches = e.match(message)
        next if matches.nil?

        return result_for matches
      end

      NIL_RESULT
    end

    private

    def result_for(matches)
      amount = matches[1].to_f
      description = matches[2].strip
      timestamp = DateTime.parse(matches[3]).to_time.utc.iso8601

      { amount: amount, description: description, timestamp: timestamp }
    end
  end
end
