#!/usr/bin/ruby

require_relative 'mailer'
require_relative 'parser'
require_relative 'translator'

module Rol
	class Processor
		def Processor.process
			emails = Rol::Mailer.get_all_with_attachments
			emails.each do | email |
				email[ :attachments ].each do | contents |
					parsed = Rol::Parser.parse( contents )
					translated = Rol::Translator.translate( parsed )
					translated.each do | tx |
						puts tx
					end
					# filtered = Rol::Filter.filter( translated )
					# Rol::Store.store( filtered )
				end
			end
		end
	end
end
