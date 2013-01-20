#!/usr/bin/ruby

require 'ruby-debug'
require 'yaml'
require 'bigdecimal'
require 'mail'
require_relative 'lib/mailer' 
require_relative 'lib/processor' 

def read_text_from_file
	file = File.new( "out2.txt" )
	full_text = file.read

	return [ full_text ]
end

def get_text_for_messages
	return read_text_from_file

	config = YAML.load( File.new( 'config.y' ) )

	Mail.defaults do
		retriever_method :imap, {
			:address    => 'imap.gmail.com',
			:port       => 993,
			:enable_ssl => true,
			:user_name  => config[ :user ],
			:password   => config[ :pass ],
		}
	end

	emails = Rol::Mailer.get_all
	emails.map do | email |
		email[ :body ]
	end
end

def parse( messages )
	results = []

	messages.each do | full_text |
		entradas = full_text.scan( /^(\d\d-\d\d-\d\d\d\d)\s+(.*?)\s+R\$\s([0-9,.]+).*$/ )
		entradas.each do | entrada |
			data, estabelecimento, valor = entrada
			data = Date.parse( data )
			valor = BigDecimal.new( valor.gsub( ",", "virgula" ).gsub( ".", "," ).gsub( "virgula", "." ) )

			result = { "data" => data, "estab" => estabelecimento, "valor" => valor }
			results.push result
		end

		#bandeira = full_text.scan( /CARTAO PERSONNALITE (.*) PLATINUM/ )[ 0 ]

		#lines = full_text.split( "\n" )

		#debugger
		#current = 0
		#lines.each do | line |
			#numero = line.scan( /final ...(\d*)/ )[ 0 ]
			#if !numero.nil?
		#end
	end

	return results
end

def main
	#tag_map = {
		#"EXTRA 1341 SA" => [ "#mercado", "#extraitaim" ],
		#"R M R COM DE GAS SA" => [ "#gas" ],
		#"RESTAURANTE CHOUPANA OL" => [ "#alimentacao", "#viagem" ],
	#}
	#tags = tag_map[ estabelecimento ]

	messages = get_text_for_messages
	parsed = parse( messages )

	parsed.each do | item |
		puts item
	end
	
end

main
