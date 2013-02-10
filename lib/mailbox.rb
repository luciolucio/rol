require 'gmail'

class Mailbox
	@@session = nil

	def initialize( user, password )
		if @@session.nil?
			session = Gmail.new( user, password )
			@@session = session
		end
	end

	def get_all_unprocessed
		return @@session.mailbox( "rol-unprocessed" ).emails(
			:from => "itau-unibanco.com.br",
		).collect { | m | Message.new( m ) }
	end
end
