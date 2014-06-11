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
        Rol::Storage::TestStorage.stored_expenses
      end

      def save_expense(e)
        Rol::Storage::TestStorage.stored_expenses << e
      end
    end
  end
end
