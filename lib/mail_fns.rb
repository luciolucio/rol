#!/usr/bin/ruby

require 'net/imap'
require 'mail'
require 'openssl'
require 'yaml'

module Rol
	module MailFns
		# E-mail library to deal with gmail's IMAP

		# Returns an array in which each item is a hash like so:
		# { body, html_body, attachments }
		def MailFns.get_all
			begin
				config = YAML.load( File.new( 'config.y' ) )
				all = []

				imap = Net::IMAP.new( 'imap.gmail.com', 993, true, nil, false )
				imap.login( config[ :user ], config[ :pass ] )
				imap.select( 'Inbox' )

				imap.search( [ "ALL" ] ).each do | message_id |
					msg = imap.fetch( message_id, 'RFC822' )[ 0 ].attr[ 'RFC822' ]

					mail = Mail.new( msg )
					if( !mail.multipart? )
						data = {
							:body => mail.body.decode,
							:html_body => mail.body.decode,
							:attachments => nil
						}
					else
						data = {}
						mail.parts.each do | part |
							attachments = []
							if( part.attachment? )
								attachments.push( part.body )
								next
							elsif( part.content_type.start_with?( 'text/html' ) )
								data[ :html_body ] = part.body
							elsif( part.content_type-start_with?( 'text/plain' ) )
								data[ :body ] = part.body
							else
								raise "Unsupported e-mail message"
							end

							data[ :attachments ] = attachments
						end
					end

					all.push( data )
				end

				all
			ensure
				imap.close unless imap.nil?
			end
		end
	end
end

puts Rol::MailFns.get_all
