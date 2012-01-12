#!/usr/bin/ruby

require 'net/imap'
require 'mail'
require 'yaml'

module Rol
	module MailFns
		# E-mail library to deal with gmail's IMAP

		# Returns an array in which each item is a hash like so:
		# { subject, body, html_body, attachments }
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
					data = {
						:subject => mail.subject,
						:attachments => [],
						:body => mail.body,
						:html_body => mail.body,
					}

					if( mail.multipart? )
						data.merge! get_all_parts_flat( mail )
					end

					all.push( data )
				end

				all
			ensure
				imap.close unless imap.nil?
			end
		end

		private

		# Returns each part of the given item as:
		# { body, html_body, attachments }
		def MailFns.get_all_parts_flat( item )
			data = { :attachments => [] }

			item.parts.each do | part |
				if( part.attachment? )
					data[ :attachments ].push( part.body )
				elsif( part.multipart? )
					child_data = get_all_parts_flat( part )
					attachments = child_data[ :attachments ]
					data[ :attachments ].push( attachments ) unless attachments.empty?
					data[ :body ] = child_data[ :body ]
					data[ :html_body ] = child_data[ :html_body ]
				elsif( part.content_type.start_with?( 'text/html' ) )
					data[ :html_body ] = part.body
				elsif( part.content_type.start_with?( 'text/plain' ) )
					data[ :body ] = part.body
				else
					raise "Unsupported e-mail message. Non-multipart content type is %s." % [ part.content_type ]
				end
			end

			data
		end

	end
end
