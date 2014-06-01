# -*- coding: UTF-8 -*-

# 'Your Debit Card Transaction' email from Chase
class ChaseDebitCardTransaction
  def self.from_message(message)
    ChaseDebitCardTransaction.new(message)
  end

  def to_expense
    expr = /A \$(.*) debit card transaction to (.*) on (.*) exceeded/
    matches = expr.match(@body)
    amount = matches[1].to_f
    description = matches[2].strip
    timestamp = DateTime.parse(matches[3]).to_time.utc.iso8601

    { amount: amount, description: description, timestamp: timestamp }
  end

  private

  def initialize(message)
    @body = message.body.decoded
  end
end
