# -*- coding: UTF-8 -*-

require_relative '../../lib/rol'
require 'test/unit'
require 'mail'

# Something to respond to initialize(one arg)
# Set as the default, so we can test
# that we are retrieving using the method
# from the user
class NoMethod
  def initialize(_settings)
  end
end

# Tests for extensions to Mail
class TestMail < Test::Unit::TestCase
  def setup_user
    @user = Rol::User.new do
      recipient 'recipient@email.com'
      retriever_method :test
    end
  end

  def setup_email
    @email = Mail.new do
      to 'someone@example.com'
      from 'you@you.co'
      subject 'testing'
      body 'hi ya'
    end
  end

  def setup
    setup_user
    setup_email

    Mail.defaults do
      retriever_method NoMethod
    end

    Mail::TestMailer.deliveries.clear
    Mail::TestRetriever.emails = [@email.dup]
  end

  def test_should_retrieve_using_method_from_user
    emails = Mail.for(@user)
    assert_equal(1, emails.size)
    assert_equal(@email, emails.first)
  end

  def test_should_retrieve_with_options
    emails = Mail.for(@user, what: :last)
    assert_equal(1, emails.size)
    assert_equal(@email, emails.first)
  end

  def test_should_retrieve_with_block
    Mail.for(@user) do |m|
      assert_equal(@email, m)
    end
  end

  def test_should_set_user_on_each_message
    emails = Mail.for(@user)
    assert_equal(@user, emails.first.user)
  end

  def test_should_set_user_on_each_message_with_block
    Mail.for(@user) do |m|
      assert_equal(@user, m.user)
    end
  end
end
