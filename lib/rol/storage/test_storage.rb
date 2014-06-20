# -*- coding: UTF-8 -*-
# rubocop:disable TrivialAccessors

module Rol
  module Storage
    # Storage test class
    class TestStorage
      include Storage

      @stored_expenses = []

      def self.stored_expenses
        @stored_expenses
      end

      def self.clear
        @stored_expenses.clear
      end

      private

      def save_expense(e)
        Rol::Storage::TestStorage.stored_expenses << e.clone
      end

      def all
        Rol::Storage::TestStorage.stored_expenses.clone
      end

      def save_all_expenses(expenses)
        Rol::Storage::TestStorage.clear

        expenses.each do |e|
          save_expense(e)
        end
      end
    end
  end
end
