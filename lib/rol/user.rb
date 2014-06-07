# -*- coding: UTF-8 -*-

module Rol
  # A user in the system
  class User
    attr_writer :recipient

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def recipient(recipient = nil)
      return @recipient if recipient.nil?
      @recipient = recipient
    end

    def retriever_method(method = nil, settings = {})
      return @retriever_method if @retriever_method && method.nil?

      if :gmail == method
        settings[:address] = 'imap.gmail.com'
        settings[:port] = 993
        settings[:enable_ssl] = true
        @retriever_method = Mail::IMAP.new(settings)
      else
        @retriever_method = Mail::Configuration.instance
          .lookup_retriever_method(method).new(settings)
      end
    end
  end
end
