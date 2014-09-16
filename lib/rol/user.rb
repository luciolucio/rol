# -*- coding: UTF-8 -*-

module Rol
  # A user in the system
  class User
    attr_accessor :recipient, :delivery_settings

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

    def delivery_method(method = nil, settings = {})
      return @delivery_method if @delivery_method && method.nil?

      if :gmail == method
        @delivery_method = :smtp
        @delivery_settings = delivery_options(settings)
      else
        @delivery_method = method
        @delivery_settings = settings
      end
    end

    def format(format = nil)
      return @format if format.nil?
      @format = Rol::Format::PlainText.new
    end

    private

    def delivery_options(settings)
      settings.merge(
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               'gmail.com',
        authentication:       'plain',
        enable_starttls_auto: true)
    end
  end
end
