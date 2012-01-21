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
					:body        => msg.body.decoded,
					:html_body   => msg.body.decoded,
				}

				if( msg.multipart? )
					data[ :body ]        = msg.text_part.body.decoded
					data[ :html_body ]   = msg.html_part.body.decoded
					data[ :attachments ] = get_attachments( msg )
				end

				all.push( data )
			end

			all
		end

		private

		def MailFns.get_attachments( item )
			data = []

			item.attachments.each do | attachment |
				data.push( attachment.body.decoded )
			end

			data
		end

	end
end
