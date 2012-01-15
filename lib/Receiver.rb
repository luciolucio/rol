#!/usr/bin/ruby

require 'yaml'
require 'mail'
require_relative 'mail_fns' 

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

puts Rol::MailFns.get_all
