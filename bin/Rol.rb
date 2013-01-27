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

def parse( message )
	parsed = [] 

	full_text = message.text_part.body.decoded
	card_type = full_text.scan( /CARTAO PERSONNALITE (.*) PLATINUM/ ).first.first
	lines = full_text.split( "\n" )

	card_no = 0

	lines.each do | line |
		number = line.scan( /final ...(\d*)/ ).first
		if number.nil? && card_no == 0
			next
		elsif !number.nil?
			card_no = number.first
		else
			entry = line.scan( /^(\d\d-\d\d-\d\d\d\d)\s+(.*?)\s+R\$\s([0-9,.]+).*$/ ).first
			if entry.nil?
				next
			else
				date, seller, value = entry
				date = Date.parse( date )
				value = BigDecimal.new( value.gsub( ",", "virgula" ).gsub( ".", "," ).gsub( "virgula", "." ) )
				result = Expense.new( card_type, card_no, date, seller, value )
				parsed.push result
			end
		end
	end

	parsed
end

def main
	#tag_map = {
		#"EXTRA 1341 SA" => [ "#mercado", "#extraitaim" ],
		#"R M R COM DE GAS SA" => [ "#gas" ],
		#"RESTAURANTE CHOUPANA OL" => [ "#alimentacao", "#viagem" ],
	#}
	#tags = tag_map[ seller ]

	config = YAML.load( File.new( '../config/config.y' ) )
	user = config[ :user ]
	password = config[ :pass ]
	mbox = Mailbox.new( user, password )
	messages = filter( mbox.get_all_unprocessed )

	messages.each do | message |
		parsed = parse( message )
		message.archive!
		parsed.each do | p |
			puts p.inspect
		end
	end
end

main
