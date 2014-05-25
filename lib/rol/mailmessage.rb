# -*- coding: UTF-8 -*-

module Rol
  # This is the very model of an email message
  class MailMessage
    attr_reader :id
    attr_accessor :body

    def initialize(id, body = '')
      @id   = id
      @body = body
    end
  end
end
