# -*- coding: UTF-8 -*-
require 'mail'

module Mail
  # Extending Message with stuff we need in rol
  class Message
    # Categorizes a message by attempting at each
    # different message parser. Notice that this is
    # dependent on the order of the parsers
    def categorize
      Rol.message_parsers.each do |p|
        parsed = p.from_message(self)
        return parsed unless parsed.nil?
      end

      nil
    end
  end
end
