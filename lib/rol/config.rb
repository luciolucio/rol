module Rol
  # Main configuration for Rol
  module Config
    module_function

    def parameter(*names)
      names.each do |name|
        attr_accessor name

        define_method name do |*values|
          value = values.first
          value ? send("#{name}=", value) : instance_variable_get("@#{name}")
        end
      end
    end

    def config(&block)
      instance_eval(&block)
    end
  end
end
