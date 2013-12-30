# -*- coding: UTF-8 -*-

module Rol
  # This is a container for Mail objects. It manages
  # the connection and uses it to get data

  class Mailbox
    @connected = false

    def connected?
      @connected
    end

    def initialize(connection)
      @connection = connection

      connection.connect
      @connected = true
    end

    def get_messages
      @connection.get_messages
    end
  end
end
