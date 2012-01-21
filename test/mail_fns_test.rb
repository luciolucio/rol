require_relative '../lib/mail_fns'
require 'mail'
require 'test/unit'

class TestMailFns < Test::Unit::TestCase
	@@text = 'This is plain text'
	@@html_text = '<h1>This is HTML</h1>'
	@@html_content_type = 'text/html; charset=UTF-8'

	@@mail = {
		:simple => {
			:email => Mail.new do
				body 'DEF'
			end,
			:expected => {
				:subject     => nil,
				:body        => 'DEF',
				:html_body   => 'DEF',
				:attachments => [],
			},
		},

		:html => {
			:email => Mail.new do
				text_part { body @@text }
				html_part { body @@html_text; content_type @@html_content_type }
			end,
			:expected => {
				:subject     => nil,
				:body        => @@text,
				:html_body   => @@html_text,
				:attachments => [],
			},
		},

		:simple_with_attachment => {
			:email => Mail.new do
				text_part { body "" }
				html_part { body "" }
			end.tap do | m |
				m.attachments[ 'file.txt' ] = '123456'
			end,
			:expected => {
				:subject     => nil,
				:body        => "",
				:html_body   => "",
				:attachments => ['123456'],
			},
		},

		:html_with_attachment => {
			:email => Mail.new do
				text_part { body @@text }
				html_part { body @@html_text; content_type @@html_content_type }
			end.tap do | m |
				m.attachments[ 'file.txt' ] = '123456'
			end,
			:expected => {
				:subject     => nil,
				:body        => @@text,
				:html_body   => @@html_text,
				:attachments => ['123456'],
			},
		},
	}

	def setup
		Mail.defaults do
			retriever_method :test
		end
	end

	def test_get_all
		@@mail.each do | description, data |
			Mail::TestRetriever.emails = [ data[ :email ] ]
			all = Rol::MailFns.get_all

			actual   = all[ 0 ]
			expected = data[ :expected ]

			print "[%s]\nExpected: %s\n  Actual: %s\n\n" % [ description.to_s, expected, actual ]
			assert( actual == expected, description.to_s )
		end
	end
end
