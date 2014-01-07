# -*- coding: UTF-8 -*-
require 'gmail'

module Rol
  # This is a connection to a gmail account

  class GmailConnection
    SECONDS_IN_DAY = 24 * 60 * 60

    def initialize(username, password)
      @session = Gmail.new(username, password)
    end

    def find_all(options)
      days = options[:days] || 3
      from = options[:from] || ''

      @session.inbox.emails(
          after: Time.now - days * SECONDS_IN_DAY,
          from: from).map do |m|
        full_text = m.body.decoded
        MailMessage.new(full_text)
      end
    end
  end
end
