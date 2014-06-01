# -*- coding: UTF-8 -*-

# 'Your Debit Card Transaction' email from Chase
class ChaseDebitCardTransaction
  def self.from_message(message)
    ChaseDebitCardTransaction.new
  end

  def to_expense
    { amount: 3.76, description: 'PIER 49 PIZZA - SALT', timestamp: '2013-12-24T19:13:48Z' }
  end
end
