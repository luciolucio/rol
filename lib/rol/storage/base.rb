# -*- coding: UTF-8 -*-

module Rol
  # Base save and find methods
  module Storage
    def save(e)
      ex = find(input_message_id: e.input_message_id)

      if ex.nil?
        save_expense(e)
      else
        new = all.map do |e_stored|
          e_stored.input_message_id == e.input_message_id ? e : e_stored
        end

        save_all_expenses(new)
      end
    end

    def find(fields = {})
      all.each do |ex|
        match = true

        # rubocop: disable UnusedBlockArgument
        fields.each do |k, v|
          field_matches = ex.send(k) == v
          match = false unless field_matches
        end
        # rubocop: enable UnusedBlockArgument

        return ex.clone if match
      end

      nil
    end
  end
end
