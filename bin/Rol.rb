#!/usr/bin/ruby

require 'yaml'
require 'bigdecimal'
require_relative '../lib/message'
require_relative '../lib/mailbox'
require_relative '../lib/expense'

def filter( messages )
	messages.select do | m |
		m.subject.include? "ltimas trans" and m.subject.include? "realizadas com o cart"
	end
end


def main
	config = YAML.load( File.new( '../config/config.y' ) )
	user = config[ :user ]
	password = config[ :pass ]

	mbox = Mailbox.new( user, password )
	messages = filter( mbox.get_all_unprocessed )

	messages.each do | message |
		full_text = message.text_part.body.decoded
		expenses = Expense.parse( full_text )
		#message.archive!

		expenses.each do | e |
			puts e.inspect
		end
	end
end

main