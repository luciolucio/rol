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

      # TODO: Put an actual default storage here
      storage :temp_file
    end

    def message_types(types = nil)
      return @message_types if types.nil?
      @message_types = types
    end

    def storage(storage_type = nil)
      return @storage_type if @storage_type && storage_type.nil?
      @storage_type = lookup_storage_method(storage_type).new
    end

    def lookup_storage_method(method)
      case method.is_a?(String) ? method.to_sym : method
      when :test
        Rol::Storage::TestStorage
      when :temp_file
        Rol::Storage::TempFile
      else
        method
      end
    end
  end
end
