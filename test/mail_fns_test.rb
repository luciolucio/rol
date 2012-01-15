require_relative '../lib/mail_fns'
require 'mail'
require 'test/unit'

class TestMailFns < Test::Unit::TestCase
	@@msg = Mail.new do
		to      'somebody@example.com'
		from    'someone@example.com'
		subject 'S1'
		body    'B1'
	end

	def setup
		Mail.defaults do
			retriever_method :test
		end
	end

	def test_non_multipart
		Mail::TestRetriever.emails = [ @@msg ]

		# {:subject=>"S1", :attachments=>[], :body=>B1, :html_body=>B1}
		all = Rol::MailFns::get_all

		assert all.length == 1

		mail = all[ 0 ]
		assert mail[ :subject ]     == @@msg.subject
		assert mail[ :body ]        == @@msg.body
		assert mail[ :html_body ]   == @@msg.body
		assert mail[ :attachments ] == []
	end
end
