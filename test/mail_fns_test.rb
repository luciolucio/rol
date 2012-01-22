require_relative '../lib/mail_fns'
require 'mail'
require 'test/unit'

class TestMailFns < Test::Unit::TestCase
	@@text = 'This is plain text'
	@@html_text = '<h1>This is HTML</h1>'
	@@html_content_type = 'text/html; charset=UTF-8'

	@@mail_scenarios = {
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

		:simple_with_multiple_attachments => {
			:email => Mail.new do
				text_part { body "" }
				html_part { body "" }
			end.tap do | m |
				m.attachments[ 'file1.txt' ] = '123456'
				m.attachments[ 'file2.txt' ] = '123457'
			end,
			:expected => {
				:subject     => nil,
				:body        => "",
				:html_body   => "",
				:attachments => [ '123456', '123457' ],
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
				:attachments => [ '123456' ],
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

	@@multiple_mail_scenarios = [
			[ :simple, :html ],
			[ :simple, :simple_with_attachment ],
			[ :html_with_attachment, :simple_with_multiple_attachments, :html ],
			@@mail_scenarios.keys,
			[],
	]

	@@attachments_scenarios = [
		{
			:mail_scenarios   => [ :simple, :simple_with_attachment ],
			:expected_with    => [ :simple_with_attachment ],
			:expected_without => [ :simple ],
		},
		{
			:mail_scenarios   => [ :simple, :html ],
			:expected_with    => [],
			:expected_without => [ :simple, :html ],
		},
		{
			:mail_scenarios   => [ :html_with_attachment ],
			:expected_with    => [ :html_with_attachment ],
			:expected_without => [],
		},
		{
			:mail_scenarios   => [ :html_with_attachment, :simple_with_multiple_attachments ],
			:expected_with    => [ :html_with_attachment, :simple_with_multiple_attachments ],
			:expected_without => [],
		},
		{
			:mail_scenarios   => [ :simple_with_attachment, :simple, :html_with_attachment, :simple_with_multiple_attachments ],
			:expected_with    => [ :simple_with_attachment, :html_with_attachment, :simple_with_multiple_attachments ],
			:expected_without => [ :simple ],
		},
		{
			:mail_scenarios   => [],
			:expected_with    => [],
			:expected_without => [],
		},
	]

	def setup
		Mail.defaults do
			retriever_method :test
		end
	end

	def test_get_all
		@@mail_scenarios.each do | description, data |
			Mail::TestRetriever.emails = [ data[ :email ] ]
			all = Rol::MailFns.get_all

			actual   = all[ 0 ]
			expected = data[ :expected ]

			assert_equal( expected, actual, description.to_s )
		end

		@@multiple_mail_scenarios.each do | keys |
			items    = keys.collect { | item | @@mail_scenarios[ item ] }
			emails   = keys.collect { | item | @@mail_scenarios[ item ][ :email ] }
			expected = items.collect { | item | item[ :expected ] }

			Mail::TestRetriever.emails = emails
			all = Rol::MailFns.get_all

			assert_equal( expected, all, keys )
		end
	end

	def test_get_all_with_attachments
		@@attachments_scenarios.each do | scenario |
			Mail::TestRetriever.emails = scenario[ :mail_scenarios ].collect do | item |
				@@mail_scenarios[ item ][ :email ]
			end

			expected = scenario[ :expected_with ].collect do | item |
				@@mail_scenarios[ item ][ :expected ]
			end

			assert_equal( expected, Rol::MailFns.get_all_with_attachments )
		end
	end

	def test_get_all_without_attachments
		@@attachments_scenarios.each do | scenario |
			Mail::TestRetriever.emails = scenario[ :mail_scenarios ].collect do | item |
				@@mail_scenarios[ item ][ :email ]
			end

			expected = scenario[ :expected_without ].collect do | item |
				@@mail_scenarios[ item ][ :expected ]
			end

			assert_equal( expected, Rol::MailFns.get_all_without_attachments )
		end
	end
end
