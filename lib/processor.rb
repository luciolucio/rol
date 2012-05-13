#!/usr/bin/ruby

require_relative 'mailer'
require_relative 'parser'

module Rol
	class Processor
		def Processor.process
			emails = Rol::Mailer.get_all_with_attachments
			emails.each do | email |
				email[ :attachments ].each do | contents |
					parsed = Rol::Parser.parse( contents )
					print parsed
					# translated = Rol::Translator.translate( parsed )
					# Rol::Store.store( translated )
				end
			end
		end
	end
end
