# -*- coding: UTF-8 -*-
require 'mail'

module Mail
  # Extending Message with stuff we need in rol
  class Message
    def categorize
      Rol::Message::OnesMessage.from_message(self)
    end
  end
end
