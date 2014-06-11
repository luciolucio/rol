# -*- coding: UTF-8 -*-

module Rol
  # An Expense represents an expense
  # parsed from a Mail::Message
  class Expense
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    attr_accessor :amount
    attr_accessor :description
    attr_accessor :timestamp
    attr_accessor :input_message_id

    def amount(amt = nil)
      return @amount if amt.nil?
      @amount = amt
    end

    def description(desc = nil)
      return @description if desc.nil?
      @description = desc
    end

    def timestamp(ts = nil)
      return @timestamp if ts.nil?
      @timestamp = ts
    end

    def input_message_id(id = nil)
      return @input_message_id if id.nil?
      @input_message_id = id
    end

    def save
      Rol.storage.save_expense(self)
    end

    def ==(other)
      amount == other.amount &&
      description == other.description &&
      timestamp == other.timestamp &&
      input_message_id == other.input_message_id
    end

    def inspect
      "#<Rol::Expense: #{@amount} at #{@description}" \
      "on #{@timestamp}. From message_id: #{@input_message_id}>"
    end
  end
end
