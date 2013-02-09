require_relative 'store'

class Expense
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
		map = Store.get( "Map Description" )[ :description_map ]
		map[ @seller ] || @seller
	end

	def tags
		map = Store.get( "Map Tag" )[ :tag_map ]
		map[ @seller ] || []
	end

	class << self
		def samples
			return [
				Expense.new( "VISA", "1315", Date.parse( "20130208" ), "LJ AMERICANAS", 15.8 ),
				Expense.new( "VISA", "1315", Date.parse( "20130208" ), "POLTRONAS X", 15.7 ),
			]
		end

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
