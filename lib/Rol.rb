#!/usr/bin/ruby

require 'yaml'
require 'mail'
require_relative 'mailer' 
require_relative 'processor'

config = YAML.load( File.new( 'config.y' ) )

Mail.defaults do
	retriever_method :imap, {
		:address    => 'imap.gmail.com',
		:port       => 993,
		:enable_ssl => true,
		:user_name  => config[ :user ],
		:password   => config[ :pass ],
	}
end

Rol::Processor.process
