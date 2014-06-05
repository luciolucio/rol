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
          timestamp: expense.timestamp
        }

        hash.to_json
      end

      def save_expense(e)
        File.open(@temp_filename, 'a') do |f|
          f.puts jsonify(e) unless e.amount.nil?
        end
      end

      def inspect
        "#<Rol::Storage::TempFile: #{@temp_filename}>"
      end
    end
  end
end