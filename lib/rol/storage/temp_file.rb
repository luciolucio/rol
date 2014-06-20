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

      def jsonify(expense)
        hash = {
          amount: expense.amount,
          store_name: expense.store_name,
          timestamp: expense.timestamp,
          input_message_id: expense.input_message_id,
          output_message_id: expense.output_message_id,
          answer_ids: expense.answer_ids
        }

        hash.to_json
      end

      def unjsonify(line)
        json = JSON.parse(line)

        ex = Expense.new do
          amount json['amount']
          store_name json['store_name']
          timestamp json['timestamp']
          input_message_id json['input_message_id']
          output_message_id json['output_message_id']
        end

        ex.answer_ids = json['answer_ids']
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
