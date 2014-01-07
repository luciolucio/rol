# -*- coding: UTF-8 -*-

module Rol
  # This is the model of an expense parsed from Chase
  # It manages a connection and uses it to get data

  class ChaseExpense
    def initialize(connection)
      @connection = connection
      @parser = Rol::ChaseParser.new
    end

    def find_by_days_ago(days_ago)
      @connection.find_all(from: 'chase.com', days: days_ago).each do |m|
        yield @parser.parse(m.body)
      end
    end
  end
end
