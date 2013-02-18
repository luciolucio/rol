#!/usr/bin/ruby

require 'configuration'
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
	Configuration.path = File.dirname( __FILE__ ) + "/../config"
	config = Configuration.load "config"
	email = config.email
	gmail = config.gmail

	mbox = Mailbox.new( gmail.user, gmail.password )
	mbox.deliver( config.email, subject, text_part )
end

main
