#!/usr/bin/ruby

require 'yaml'
require 'bigdecimal'
require_relative '../lib/message'
require_relative '../lib/mailbox'

def filter( messages )
	messages.keep_if do | m |
		m.subject.include? "ltimas trans" and m.subject.include? "realizadas com o cart"
	end
end

def parse( message )
	parsed = [] 

	full_text = message.text_part.body.decoded
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
	#tags = tag_map[ estabelecimento ]

	config = YAML.load( File.new( '../config/config.y' ) )
	user = config[ :user ]
	password = config[ :pass ]
	mbox = Mailbox.new( user, password )
	messages = filter( mbox.get_all_unprocessed )

	messages.each do | message |
		parsed = parse( message )
		message.archive!
		parsed.each do | p |
			puts p
		end
	end
end

main
