#!/usr/bin/ruby

require 'yaml'
require_relative '../lib/expense'
require_relative '../lib/message'
require_relative '../lib/mailbox'
require_relative '../lib/mailprocessortrigger'
require_relative '../lib/outgoingmessage'
require_relative '../lib/store'

def main
	triggers = MailProcessorTrigger.get( :unprocessed )
	
	triggers.each do | t |
		# TODO: think about the best way to send this dependency into OutgoingMessage. Is this the best way?
		message = OutgoingMessage.new( t.id, t.expenses, self.method( "send_method" ) )
		message.send!

		t.status = :reported
		Store.save( t )
	end
end

def send_method( subject, text_part )
	puts "Sending email with subject '%s' and text_part as follows:\n%s\n\n" % [ subject, text_part ]
end

main
