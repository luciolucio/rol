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

    def save
      Rol.storage.save_expense(self)
    end
  end
end
