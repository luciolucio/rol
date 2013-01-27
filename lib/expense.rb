class Expense
	def initialize( card_type, card_no, date, seller, value )
		@card_type = card_type
		@card_no = card_no
		@date = date
		@seller = seller
		@value = value
	end

	def inspect
		"#<#{self.class}:#{self.object_id}, #{@card_type} #{@card_no} #{@date} #{@seller} %.2f>" % @value
	end
end
