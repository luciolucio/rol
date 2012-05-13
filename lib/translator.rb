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
			{
				:descricao => /^CH COMPENSADO/,
				:replace   => "Cheque",
			},
			{
				:descricao => /^TAR MULTICTA/,
				:replace   => "Tarifa de conta",
			},
			{
				:descricao => /INT PAG TIT BANCO 033/,
				:valor     => 787.07,
				:replace   => "Faculdade Muri",
			},
			{
				:descricao => /^INT PAG TIT BANCO/,
				:replace   => "Boleto",
			},
			{
				:descricao => /^INT NET|SISDEB NET SP/,
				:replace   => "NET",
			},
			{
				:descricao => /CARTAO PERSONNALITE/,
				:replace   => "Cartao de credito",
			},
			{
				:descricao => /LICENC SP (\d+)/,
				:replace   => "Licenciamento RENAVAM %s",
			},
			{
				:descricao => /INT 8482.14128-3/,
				:replace   => "Condominio",
			},
			{
				:descricao => /INT 2958.00090-9/,
				:replace   => "Aluguel",
			},
			{
				:descricao => /ELETROPAULO/,
				:replace   => "Luz",
			},
		]

		def Translator.translate( data )
			data.each do | entry |
				desc = entry[ :descricao ]

				@@rules.each do | rule |
					matches = rule[ :descricao ].match( desc )
					if( !matches.nil? )
						if( !rule.has_key?( :valor ) || ( rule.has_key?( :valor ) && rule[ :valor ] == entry[ :valor ] ) )
							entry[ :descricao ] = rule[ :replace ] % matches.captures
							break
						end
					end
				end
			end
		end
	end
end
