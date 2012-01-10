lines = File.new( ARGV[ 0 ] ).readlines

line_match = /.*?\b(\d\d\/\d\d)\b\s+([\w\s\$-.]*?) ?(\d\d\/\d\d)?\s+(-?\d+,\d+).*/

data = []
lines.each do | line |
	if line_match.match( line )
		scan = line.scan( line_match )[ 0 ]
		data.push( {
			:data      => scan[ 0 ],
			:descricao => scan[ 1 ],
			:parcela   => scan[ 2 ],
			:valor     => scan[ 3 ],
		} )
	end
end

puts data
