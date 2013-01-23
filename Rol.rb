#!/usr/bin/ruby

require 'yaml'
require 'bigdecimal'
require 'mail'
require_relative 'lib/mailer' 
require_relative 'lib/processor' 

def read_text_from_file
	file = File.new( "out3.txt" )
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
		bandeira = full_text.scan( /CARTAO PERSONNALITE (.*) PLATINUM/ )[ 0 ]
		lines = full_text.split( "\n" )

		cartao_final = 0

		lines.each do | line |
			numero = line.scan( /final ...(\d*)/ )[ 0 ]
			if numero.nil? && cartao_final == 0
				next
			elsif !numero.nil?
				cartao_final = numero
			else
				entrada = line.scan( /^(\d\d-\d\d-\d\d\d\d)\s+(.*?)\s+R\$\s([0-9,.]+).*$/ )[ 0 ]
				if entrada.nil?
					next
				else
					data, estabelecimento, valor = entrada
					data = Date.parse( data )
					valor = BigDecimal.new( valor.gsub( ",", "virgula" ).gsub( ".", "," ).gsub( "virgula", "." ) )
					result = { "bandeira" => bandeira, "cartao" => cartao_final, "data" => data, "estab" => estabelecimento, "valor" => valor }

					results.push result
				end
			end
		end
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
