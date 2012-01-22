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
				body = msg.body.decoded
				body = msg.text_part.body.decoded if msg.multipart?

				html_body = msg.body.decoded
				html_body = msg.html_part.body.decoded if msg.multipart?

				data = {
					:subject     => msg.subject,
					:attachments => msg.attachments.collect { | a | a.body.decoded },
					:body        => body,
					:html_body   => html_body,
				}

				all << data
			end

			all
		end

		# Returns same structure as get_all, but only those with attachments
		def MailFns.get_all_with_attachments
			get_all.select do | msg |
				not msg[ :attachments ].empty?
			end
		end
	end
end
