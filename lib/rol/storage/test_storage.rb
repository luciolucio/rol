# -*- coding: UTF-8 -*-
# rubocop:disable TrivialAccessors

module Rol
  module Storage
    # Storage test class
    class TestStorage
      @stored_expenses = []

      def self.stored_expenses
        @stored_expenses
      end

      def self.clear
        @stored_expenses.clear
      end

      def all
        Rol::Storage::TestStorage.stored_expenses.dup
      end

      def save_expense(e)
        Rol::Storage::TestStorage.stored_expenses << e.dup
      end

      def save_all_expenses(expenses)
        Rol::Storage::TestStorage.stored_expenses.clear

        expenses.each do |e|
          save_expense(e)
        end
      end
    end
  end
end
