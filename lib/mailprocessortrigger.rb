class MailProcessorTrigger < CouchRest::Document
	def initialize( expense_ids )
		super( {
			:expense_ids => expense_ids,
			:status      => :unprocessed,
			:type        => self.class,
		} )

		# FIXME: created_at is being updated in the db at each update
		super( { :created_at => Time.new } ) if !self.has_key?( :created_at )

		self.id = self.implied_name
	end

	def mush
		str = self[ :expense_ids ].join( ' ' )
		t = 0
		str.each_byte.with_index do | i, b | t += i * b end
		t.to_s
	end

	def status=( status )
		self[ :status ] = status
	end

	def implied_name
		"MPT %s %s" % [ self[ :expense_ids ].size, self.mush ]
	end

	def expenses
		self[ :expense_ids ].map { | id | Expense.from_store( id ) }
	end

	class << self
		def get( type )
			all = []

			if type == :unprocessed
				Store.view( "mailprocessor/unprocessed_triggers" )[ "rows" ].map do | row |
					t = Store.get( row[ "id" ] )

					result = MailProcessorTrigger.new( t[ :expense_ids ] )
					result.id = t.id
					result[ "_rev" ] = t.rev
					result.status = t[ :status ]

					all.push result
				end

				all
			end
		end
	end
end
