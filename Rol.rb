#!/usr/bin/ruby

require 'yaml'
require 'bigdecimal'
require 'gmail'

class Message
	def initialize( message )
		@message = message
	end

	def archive!
		@message.move_to( "processed" )
	end

	# Delegate all other methods to the Mail message
	def method_missing(*args, &block)
		if block_given?
			@message.send(*args, &block)
		else
			@message.send(*args)
		end
	end
end

class Mailbox
	@@session = nil

	def self.initialize
		if @@session.nil?
			config = YAML.load( File.new( 'config.y' ) )
			session = Gmail.new( config[ :user ], config[ :pass ] )
			@@session = session
		end
	end

	def self.get_all_unprocessed
		self.initialize

		return @@session.mailbox( "unprocessed" ).emails(
			:from => "itau-unibanco.com.br",
		).collect { | m | Message.new( m ) }
	end
end

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

	messages = Mailbox.get_all_unprocessed
	messages = filter( messages )

	messages.each do | message |
		parsed = parse( message )
		message.archive!
		parsed.each do | p |
			puts p
		end
	end
end

main
