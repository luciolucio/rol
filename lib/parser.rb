#!/usr/bin/ruby

module Rol
	class Parser
		@@line_match = /.*?\b(\d\d\/\d\d)\b\s+[DA]?\s+([\w\s\$-.\/]*?) ?(\d\d\/\d\d)?\s+([.\d]+,\d+)-.*/

		def Parser.parse( data )
			results = []

			data.split( "\n" ).each do | line |
				if @@line_match.match( line )
					scan = line.scan( @@line_match )[ 0 ]
					results.push( {
						:data      => scan[ 0 ],
						:descricao => scan[ 1 ],
						:parcela   => scan[ 2 ],
						:valor     => scan[ 3 ].gsub( ".", "" ).gsub( ",", "." ).to_f,
					} )
				end
			end

			results
		end
	end
end
