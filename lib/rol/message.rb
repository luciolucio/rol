# -*- coding: UTF-8 -*-
require 'mail'

module Mail
  # Extending Message with stuff we need in rol
  class Message
    # Categorizes a message by attempting at each
    # different message type. Notice that this is
    # dependent on the order of the types
    def categorize
      Rol.message_types.each do |p|
        msg = p.from_message(self)
        return msg unless msg.nil?
      end

      nil
    end
  end
end
