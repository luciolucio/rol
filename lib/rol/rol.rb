# -*- coding: UTF-8 -*-

# Main Rol module
# For big time important stuff such as config
module Rol
  def self.config(&block)
    Config.instance.instance_eval(&block)
  end

  def self.message_parsers
    Config.instance.message_parsers
  end
end
