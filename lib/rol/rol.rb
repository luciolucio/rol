# -*- coding: UTF-8 -*-

# Main Rol module
# For big time important stuff such as config
module Rol
  def self.config(&block)
    Config.instance.instance_eval(&block)
  end

  def self.message_types
    Config.instance.message_types
  end

  def self.storage
    Config.instance.storage
  end
end
