class OutgoingMessage < Message
	def initialize( expenses, send_method )
		throw "Need some expenses to send!" if expenses.empty?

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
		"Subject"
	end

	def textonly
		"Textonly"
	end
end
