#!/usr/bin/ruby

require 'yaml'
require 'mail'
require_relative 'lib/mailer' 
require_relative 'lib/processor' 

def get_text_for_messages
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

	emails = Rol::Mailer.get_all
	emails.each do | email |
		puts email[ :body ]
	end
end

# get_text_for_messages

text = File.new( "out.txt" ).read
puts text
