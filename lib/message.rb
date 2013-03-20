module Rol
	class Message
		def initialize( message )
			@message = message
		end

		def archive!
			@message.move_to( "rol-processed" )
		end

		# Delegate all other methods to the Mail message
		def method_missing(*args, &block)
			if block_given?
				@message.send(*args, &block)
			else
				@message.send(*args)
			end
		end
	end
end
