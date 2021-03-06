# -*- coding: UTF-8 -*-
require 'mail'

module Mail
  # Extending Message with stuff we need in rol
  class Message
    # Identifies a message by attempting at each
    # different message type. Notice that this is
    # dependent on the order of the types
    def identify
      Rol.message_types.each do |p|
        msg = p.from_message(self)
        return msg unless msg.nil?
      end

      Rol::Messages::UnrecognizedMessage.new
    end

    attr_accessor :user

    def user(user = nil)
      return @user if user.nil?
      @user = user
    end
  end
end
