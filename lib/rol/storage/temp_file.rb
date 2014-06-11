# -*- coding: UTF-8 -*-

require 'fileutils'
require 'json'
require 'tmpdir'

module Rol
  module Storage
    # Stores things in a temporary text file
    # Throwaway stuff just so I can run rol for now
    class TempFile
      attr_accessor :temp_filename

      def initialize
        @temp_filename = File.join(Dir.tmpdir, 'pipakes')
        FileUtils.touch(@temp_filename)
      end

      def jsonify(expense)
        hash = {
          amount: expense.amount,
          description: expense.description,
          timestamp: expense.timestamp,
          input_message_id: expense.input_message_id
        }

        hash.to_json
      end

      def unjsonify(line)
        json = JSON.parse(line)

        Expense.new do
          amount json['amount']
          description json['description']
          timestamp json['timestamp']
          input_message_id json['input_message_id']
        end
      end

      def save_expense(e)
        File.open(@temp_filename, 'a') do |f|
          f.puts jsonify(e) unless e.amount.nil?
        end
      end

      def all
        File.readlines(@temp_filename).map do |line|
          unjsonify(line)
        end
      end

      def inspect
        "#<Rol::Storage::TempFile: #{@temp_filename}>"
      end
    end
  end
end
