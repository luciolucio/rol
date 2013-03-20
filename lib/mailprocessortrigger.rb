module Rol
	class MailProcessorTrigger < CouchRest::Document
		def initialize( expense_ids )
			super( {
				:expense_ids => expense_ids,
				:created_at  => Time.new,
				:status      => :unprocessed,
				:type        => self.class,
			} )

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
						result[ :created_at ] = t[ :created_at ]
						result[ "_rev" ] = t.rev
						result.status = t[ :status ]

						all.push result
					end

					all
				end
			end
		end
	end
end
