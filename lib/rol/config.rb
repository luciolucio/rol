require 'singleton'

module Rol
  # Main configuration for Rol
  class Config
    include Singleton

    def initialize
      # TODO: Put the default types here
      @message_types = [
        Rol::Messages::ChaseDebitCardTransaction
      ]
    end

    attr_accessor :message_types

    def message_types(types = nil)
      return @message_types if types.nil?
      @message_types = types
    end
  end
end
