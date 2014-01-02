# -*- coding: UTF-8 -*-

module Rol
  # This is a container for Mail objects from a certain source.
  # It manages a connection and uses it to get data

  class ChaseMailbox
    def initialize(connection)
      @connection = connection
      @parser = Rol::ChaseParser.new
    end

    def each_message
      @connection.messages_from('chase.com').each do |m|
        yield @parser.parse(m.body)
      end
    end
  end
end
