# -*- coding: UTF-8 -*-

# Extensions for Mail
module Mail
  # rubocop: disable MethodLength
  def self.for(user, *args)
    if block_given?
      user.retriever_method.find(*args).each do |email|
        email.user = user
        yield email
      end
    else
      user.retriever_method.find(*args).map do |email|
        email.user = user
        email
      end
    end
  end
  # rubocop: enable MethodLength
end
