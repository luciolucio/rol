# -*- coding: UTF-8 -*-

module Rol
  class RolError < RuntimeError
  end

  class InvalidUsernameOrPasswordError < RolError
  end
end
