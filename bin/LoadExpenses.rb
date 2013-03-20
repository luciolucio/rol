#!/usr/bin/ruby

require 'configuration'
require_relative '../lib/expense'
require_relative '../lib/message'
require_relative '../lib/mailbox'
require_relative '../lib/mailprocessortrigger'
require_relative '../lib/store'

def main
	Configuration.path = File.dirname( __FILE__ ) + "/../config"
	config = Configuration.load "config"
	gmail = config.gmail

	mbox = Rol::Mailbox.new( gmail.user, gmail.password )
	filter_func = Rol::Expense.method( "filter" )
	messages = filter_func.call( mbox.get_all_unprocessed )

	messages.each do | message |
		full_text = message.text_part.body.decoded
		expenses = Rol::Expense.parse( full_text )

		expenses.each do | e |
			Rol::Store.save( e )
		end

		Rol::Store.save( Rol::MailProcessorTrigger.new( expenses.map { | e | e.id } ) )
		message.archive!
	end
end

main
