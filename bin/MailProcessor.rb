#!/usr/bin/ruby

require 'yaml'
require_relative '../lib/expense'
require_relative '../lib/message'
require_relative '../lib/mailbox'
require_relative '../lib/mailprocessortrigger'
require_relative '../lib/store'

def main
	triggers = Store.view( "mailprocessor/unprocessed_triggers" )
	triggers[ "rows" ].each do | trigger |
		expense = Expense.from_store( trigger[ "value" ] )
	
		# TODO: Actually process these expenses
		puts expense.inspect
	end
end

main
