class MailProcessorTrigger
	def initialize( expense_id )
		@expense_id = expense_id
		@created_at = Time.new
	end

	def id
		"MPT #{@expense_id}"
	end

	def to_document
		{
			"_id"       => self.id,
			:created_at => @created_at,
			:expense    => @expense_id,
			:status     => :unprocessed,
			:type       => self.class,
		}
	end
end
