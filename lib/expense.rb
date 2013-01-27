class Expense
	@@tag_map = {
		"EXTRA 1341 SA"           => [ "#mercado", "#extraitaim" ],
		"R M R COM DE GAS SA"     => [ "#gas", "#ocasional" ],
		"RESTAURANTE CHOUPANA OL" => [ "#alimentacao", "#viagem" ],
		"NETFLIX SA"              => [ "#netflix", "#diversao" ],
		"LINS SUSHI BAR SA"       => [ "#alimentacao", "#alimentacaoforadecasa" ],
		"B B B SA"                => [ "#casa", "#ocasional" ],
	}

	@@description_map = {
		"EXTRA 1341 SA"           => "Extra Itaim",
		"R M R COM DE GAS SA"     => "Gas",
		"RESTAURANTE CHOUPANA OL" => "Restaurante em Recife",
		"NETFLIX SA"              => "Netflix",
		"LINS SUSHI BAR SA"       => "Sushibar perto do Theatro S. Pedro",
		"B B B SA"                => "Bom Bonito Barato - Sabara",
	}

	attr_reader :card_type, :card_no, :date, :seller, :value

	def initialize( card_type, card_no, date, seller, value )
		@card_type = card_type
		@card_no = card_no
		@date = date
		@seller = seller
		@value = value
	end

	def inspect
		"#<#{self.class}:#{self.object_id}, #{@card_type} #{@card_no} #{@date} #{self.description} %.2f #{self.tags}>" % @value
	end

	def description
		@@description_map[ @seller ] || @seller
	end

	def tags
		@@tag_map[ @seller ] || []
	end

	class << self
		def parse( full_text )
			parsed = [] 

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
	end
end
