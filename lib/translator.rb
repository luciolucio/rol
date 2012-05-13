#!/usr/bin/ruby

module Rol
	class Translator
		@@rules = [
			{
				:descricao => /PORTO SEGURO PORTO SEGU/,
				:replace   => "Seguro",
			},
			{
				:descricao => /TBI 3748.08670-3\/500/,
				:replace   => "Poupanca",
			},
			{
				:descricao => /TBI (\d{4}\.\d{5}-\d\/?\d{3}?).*/,
				:replace   => "Transferencia para %s",
			},
		]

		def Translator.translate( data )
			data.each do | entry |
				desc = entry[ :descricao ]

				@@rules.each do | rule |
					matches = rule[ :descricao ].match( desc )
					if( !matches.nil? )
						if( matches.length == 1 )
							entry[ :descricao ] = rule[ :replace ]
						elsif( matches.length > 1 )
							entry[ :descricao ] = rule[ :replace ] % matches.captures
						end
					end
				end
			end
		end
	end
end
