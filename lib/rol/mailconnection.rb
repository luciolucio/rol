# -*- coding: UTF-8 -*-
require 'gmail'

module Rol
  # This is a connection to an email account

  class MailConnection
    SECONDS_IN_DAY = 24 * 60 * 60

    def initialize(username, password)
      @username = username
      @password = password
    end

    def connect
      @session = Gmail.new(@username, @password)
    end

    def get_messages
      @session.inbox.emails(after: Time.now - 3 * SECONDS_IN_DAY, from: 'chase.com').map do |m|
        full_text = m.body.decoded
        MailMessage.new(full_text)
      end
    end
  end
end
