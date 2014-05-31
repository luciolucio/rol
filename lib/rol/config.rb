require 'singleton'

module Rol
  # Main configuration for Rol
  class Config
    include Singleton

    def initialize
      # TODO: Put the actual parsers here
      @message_parsers = nil
    end

    attr_accessor :message_parsers

    def message_parsers(parsers)
      return @message_parsers if parsers.nil?
      @message_parsers = parsers
    end
  end
end
