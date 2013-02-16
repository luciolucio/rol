class OutgoingMessage < Message
	def initialize( id, expenses, send_method )
		throw "Need some expenses to send!" if expenses.empty?

		@id = id
		@expenses = expenses
		@send_method = send_method
	end

	def send!
		@send_method.call(
			self.subject,
			self.textonly
		)
	end

	def subject
		"Expenses - #{@id}"
	end

	def textonly
		result = ""
		@expenses.each do | e |
			result += "%s %s\n%s\n%s\n%s\nTags: %s\n\n" % [ e.card_type, e.card_no, e.date, e.description, e.value, e.tags.join( " " ) ]
		end

		result
	end
end
