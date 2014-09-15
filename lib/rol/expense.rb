# -*- coding: UTF-8 -*-

module Rol
  # An Expense represents an expense
  # parsed from a Mail::Message
  class Expense
    FIELDS = [:amount, :merchant_name, :description,
              :tags, :timestamp, :input_message_id,
              :output_message_id]

    def initialize(&block)
      @answer_ids = []
      @tags = []
      instance_eval(&block) if block_given?
    end

    attr_accessor :amount
    attr_accessor :merchant_name
    attr_accessor :description
    attr_accessor :tags
    attr_accessor :timestamp
    attr_accessor :input_message_id
    attr_accessor :output_message_id
    attr_accessor :answer_ids

    def amount(amt = nil)
      return @amount if amt.nil?
      @amount = amt
    end

    def merchant_name(name = nil)
      return @merchant_name if name.nil?
      @merchant_name = name
    end

    def description(desc = nil)
      return @description if desc.nil?
      @description = desc
    end

    def tags(tags = nil)
      return @tags if tags.nil?
      @tags = tags
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

    def answer_ids(ids = nil)
      return @answer_ids if ids.nil?
      @answer_ids = ids
    end

    def self.find(fields = {})
      Rol.storage.find(fields)
    end

    def save
      Rol.storage.save(self)
    end

    def ==(other)
      is_equals = true

      FIELDS.each do |f|
        is_equals &&= send(f) == other.send(f)
      end

      is_equals
    end

    def inspect
      "#<Rol::Expense:0x#{object_id} #{@amount} at #{@merchant_name} " \
      "(#{@description}) on #{@timestamp}. Tags: #{@tags} " \
      "From message_id: #{@input_message_id}. " \
      "With output_message_id: #{@output_message_id}>"
    end
  end
end
