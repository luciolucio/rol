require_relative 'store'

class Expense
	attr_reader :card_type, :card_no, :date, :seller, :value

	def initialize( card_type, card_no, date, seller, value, id = nil )
		@card_type = card_type
		@card_no = card_no
		@date = date
		@seller = seller
		@value = value
		@id = id unless id.nil? || !id.start_with?( self.implied_name )
	end

	def inspect
		"#<#{self.class}:#{self.object_id}, #{self.id} #{@card_type} #{@card_no} #{@date} #{self.description} %.2f #{self.tags.join( ' ' )}>" % @value
	end

	def mush
		str = card_type.to_s + card_no.to_s + date.to_s + seller.to_s + value.to_s

		t = 0
		str.each_byte.with_index do | i, b | t += i * b end
		t.to_s
	end

	def id
		@id || self.implied_name
	end

	def implied_name
		# TODO: collision digit
		"E CRD %s %s" % [ @date, self.mush ]
	end

	def to_document
		{
			"_id"      => self.id,
			:type      => "expense",
			:card_type => @card_type,
			:card_no   => @card_no,
			:date      => @date,
			:seller    => @seller,
			:value     => @value,
		}
	end

	def description
		map = Store.get( "Rol Description Map" )[ :description_map ]
		map[ @seller ] || @seller
	end

	def tags
		map = Store.get( "Rol Tag Map" )[ :tag_map ]
		map[ @seller ] || []
	end

	class << self
		def samples
			return [
				Expense.new( "VISA", "1315", Date.parse( "20130208" ), "LJ AMERICANAS", 15.8 ),
				Expense.new( "VISA", "1315", Date.parse( "20130208" ), "POLTRONAS X", 15.7 ),
			]
		end

		def from_store( name )
			doc = Store.get( name )
			throw( "Document %s not found" % name ) if doc.nil?

			Expense.new( doc[ :card_type ], doc[ :card_no ], Date.parse( doc[ :date ] ), doc[ :seller ], doc[ :value ], doc[ "_id" ] )
		end

		def filter( messages )
			messages.select do | m |
				m.subject.include? "ltimas trans" and m.subject.include? "realizadas com o cart"
			end
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
