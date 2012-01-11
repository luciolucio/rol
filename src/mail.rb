#!/usr/bin/ruby

require 'net/imap'
require 'openssl'
require 'yaml'

config = YAML.load( File.new( 'config.y' ) )

imap = Net::IMAP.new('imap.gmail.com', 993, true, nil, false )
imap.login( config[ :user ], config[ :pass ] )
imap.select( 'Inbox' )

imap.search( ["ALL"] ).each do | message_id |
	body = imap.fetch( message_id, 'BODY[TEXT]' )[0].attr[ 'BODY[TEXT]' ]
	puts body
end

imap.close

