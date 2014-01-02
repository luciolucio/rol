# -*- coding: UTF-8 -*-
require 'gmail'

module Rol
  # This is a connection to a gmail account

  class GmailConnection
    SECONDS_IN_DAY = 24 * 60 * 60

    def initialize(username, password)
      @session = Gmail.new(username, password)
    end

    def messages_from(sender)
      @session.inbox.emails(after: Time.now - 3 * SECONDS_IN_DAY, from: sender).map do |m|
        full_text = m.body.decoded
        MailMessage.new(full_text)
      end
    end
  end
end
