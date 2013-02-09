#!/usr/bin/ruby

require 'yaml'
require 'bigdecimal'
require_relative '../lib/expense'
require_relative '../lib/message'
require_relative '../lib/mailbox'
require_relative '../lib/mailprocessortrigger'
require_relative '../lib/store'

def main
	filename = File.expand_path( File.dirname(__FILE__) ) + '/../config/config.y'
	config = YAML.load( File.new( filename ) )
	user = config[ :email_user ]
	password = config[ :email_passwd ]

	mbox = Mailbox.new( user, password )
	filter_func = Expense.method( "filter" )
	messages = filter_func.call( mbox.get_all_unprocessed )

	messages.each do | message |
		full_text = message.text_part.body.decoded
		expenses = Expense.parse( full_text )

		expenses.each do | e |
			Store.save( e )
			Store.save( MailProcessorTrigger.new( e.id ) )
		end

		message.archive!
	end
end

main
