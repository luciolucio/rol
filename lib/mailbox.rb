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

	def deliver( to, subject, text_part )
		@@session.deliver do
			to to
			subject subject
			text_part do
				body text_part
			end
		end
	end
end
