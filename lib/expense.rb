require 'bigdecimal'
require_relative 'store'

class Expense < CouchRest::Document
	def inspect
		"#<#{self.class}:#{self.object_id}, #{self.id} #{self[ :card_type ]} #{self[ :card_no ]} #{self[ :date ]} #{self.description} %.2f #{self.tags.join( ' ' )}>" % self[ :value ]
	end

	def mush
		str = self[ :card_type ].to_s + self[ :card_no ].to_s + self[ :date ].to_s + self[ :seller ].to_s + self[ :value ].to_s

		t = 0
		str.each_byte.with_index do | i, b | t += i * b end
		t.to_s
	end

	def implied_name
		# TODO: collision digit
		"E CRD %s %s" % [ self[ :date ], self.mush ]
	end

	def description
		map = Store.get( "Rol Description Map" )[ :description_map ]
		map[ self[ :seller ] ] || self[ :seller ]
	end

	def tags
		map = Store.get( "Rol Tag Map" )[ :tag_map ]
		map[ self[ :seller ] ] || []
	end

	def initialize( card_type, card_no, date, seller, value )
		super( {
			:card_type => card_type,
			:card_no   => card_no,
			:date      => date,
			:seller    => seller,
			:value     => value,
			:type      => self.class,
		} )

		self.id = self.implied_name
	end

	class << self
		def from_store( name )
			doc = Store.get( name )
			raise "Document %s not found" % name if doc.nil?

			e = Expense.new( doc[ :card_type ], doc[ :card_no ], Date.parse( doc[ :date ] ), doc[ :seller ], doc[ :value ] )
			e.id = doc.id
			e[ "_rev" ] = doc.rev
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
