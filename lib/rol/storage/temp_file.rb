# -*- coding: UTF-8 -*-

require 'fileutils'
require 'json'
require 'tmpdir'

module Rol
  module Storage
    # Stores things in a temporary text file
    # Throwaway stuff just so I can run rol for now
    class TempFile
      include Storage

      attr_accessor :temp_filename

      def initialize
        @temp_filename = File.join(Dir.tmpdir, 'pipakes')
        FileUtils.touch(@temp_filename)
      end

      def inspect
        "#<Rol::Storage::TempFile: #{@temp_filename}>"
      end

      private

      FIELDS = [:amount, :store_name, :description,
                :timestamp, :input_message_id,
                :output_message_id, :answer_ids]

      def jsonify(expense)
        hash = {}
        FIELDS.each do |f|
          hash[f] = expense.send(f)
        end

        hash.to_json
      end

      def unjsonify(line)
        json = JSON.parse(line)

        ex = Expense.new
        FIELDS.each do |f|
          ex.send(f, json[f.to_s])
        end

        ex
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

      def save_all_expenses(expenses)
        clear_expenses

        expenses.each do |e|
          save_expense(e)
        end
      end

      def clear_expenses
        File.delete(@temp_filename)
      end
    end
  end
end
