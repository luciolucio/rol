#!/usr/bin/ruby

require 'mail'

module Rol
	module MailFns
		# Mail functions to return simple hashes with email data

		# Returns an array in which each item is a hash like so:
		# { subject, body, html_body, attachments }
		def MailFns.get_all
			all = []

			Mail.all do | msg |
				data = {
					:subject     => msg.subject,
					:attachments => [],
					:body        => msg.body,
					:html_body   => msg.body,
				}

				if( msg.multipart? )
					data.merge! get_all_parts_flat( msg )
				end

				all.push( data )
			end

			all
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
