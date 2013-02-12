class MailProcessorTrigger
	attr_accessor :status

	def initialize( expense_ids, id = nil )
		@expense_ids = expense_ids
		@created_at = Time.new if id.nil?
		@status = :unprocessed
		@id = id unless id.nil? || !id.start_with?( self.id )
	end

	def mush
		str = @expense_ids.join( ' ' )
		t = 0
		str.each_byte.with_index do | i, b | t += i * b end
		t.to_s
	end

	def id
		"MPT %s %s" % [ @expense_ids.size, self.mush ]
	end

	def expenses
		@expense_ids.map { | id | Expense.from_store( id ) }
	end

	def to_document
		{
			"_id"       => self.id,
			:created_at => @created_at,
			:expenses   => @expense_ids,
			:status     => @status,
			:type       => self.class,
		}
	end

	class << self
		def get( type )
			if type == :unprocessed
				Store.view( "mailprocessor/unprocessed_triggers" )[ "rows" ].map do | t |
					MailProcessorTrigger.new( t[ "value" ], t[ "_id" ] )
				end
			end
		end
	end
end
