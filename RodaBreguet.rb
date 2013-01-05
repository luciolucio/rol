#!/usr/bin/ruby

require 'yaml'
require 'mail'
require_relative 'mailer' 
require_relative 'processor'

config = YAML.load( File.new( 'config.y' ) )

Mail.defaults do
	retriever_method :test
end

Mail::TestRetriever.emails = [
	Mail.new do
		text_part { body "" }
		html_part { body "" }
	end.tap do | m |
		m.attachments[ 'extrato.txt' ] = File.new( '../test/testdata/extrato.txt' ).readlines.join( "\n" )
	end
]


Rol::Processor::process
