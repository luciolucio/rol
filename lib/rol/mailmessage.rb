# -*- coding: UTF-8 -*-

module Rol
  # This is the very model of an email message

  class MailMessage
    attr_accessor :body

    def initialize(body = '')
      @body = body
    end
  end
end