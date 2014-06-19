# -*- coding: UTF-8 -*-

module Rol
  # An Expense represents an expense
  # parsed from a Mail::Message
  class Expense
    def initialize(&block)
      @answer_ids = []
      instance_eval(&block) if block_given?
    end

    attr_accessor :amount
    attr_accessor :description
    attr_accessor :timestamp
    attr_accessor :input_message_id
    attr_accessor :output_message_id
    attr_accessor :answer_ids

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

    def output_message_id(id = nil)
      return @output_message_id if id.nil?
      @output_message_id = id
    end

    def self.find(fields = {})
      Rol.storage.find(fields)
    end

    def save
      Rol.storage.save(self)
    end

    def ==(other)
      amount == other.amount &&
      description == other.description &&
      timestamp == other.timestamp &&
      input_message_id == other.input_message_id &&
      output_message_id == other.output_message_id
    end

    def inspect
      "#<Rol::Expense:0x#{object_id} #{@amount} at #{@description} " \
      "on #{@timestamp}. From message_id: #{@input_message_id}. " \
      "With output_message_id: #{@output_message_id}>"
    end
  end
end
