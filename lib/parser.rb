#!/usr/bin/ruby

module Rol
	class Parser
		@@line_match = /.*?\b(\d\d\/\d\d)\b\s+[DA]?\s+([\w\s\$-.\/]*?) ?(\d\d\/\d\d)?\s+([.\d]+,\d+)-.*/

		def Parser.parse( data )
			results = []

			data.split( "\n" ).each do | line |
				matches = @@line_match.match( line )
				if !matches.nil?
					captures = matches.captures
					results.push( {
						:data      => captures[ 0 ],
						:descricao => captures[ 1 ],
						:parcela   => captures[ 2 ],
						:valor     => captures[ 3 ].gsub( ".", "" ).gsub( ",", "." ).to_f,
					} )
				end
			end

			results
		end
	end
end
