# -*- coding: UTF-8 -*-

# Tests for Rol::User
class TestUser < Test::Unit::TestCase
  @recipient = 'user@example.com'
  @user_name = 'me'
  @password = 'ILoveChocolate24x7!'

  def test_should_create_empty
    user = Rol::User.new
    assert_not_nil(user)
  end

  def test_should_create_with_recipient
    user = Rol::User.new do
      recipient @recipient
    end

    assert_equal(@recipient, user.recipient)
  end

  def test_should_create_with_test_method
    user = Rol::User.new do
      retriever_method :test
    end

    assert_equal(Mail::TestRetriever, user.retriever_method.class)
  end

  def test_should_create_with_both_method_and_recipient
    user = Rol::User.new do
      retriever_method :test
      recipient @recipient
    end

    assert_equal(Mail::TestRetriever, user.retriever_method.class)
    assert_equal(@recipient, user.recipient)
  end

  def test_should_create_with_options_settings_and_receiver
    user = Rol::User.new do
      retriever_method :gmail, user_name: @user_name,
                               password: @password
      recipient @recipient
    end

    assert_equal(Mail::IMAP, user.retriever_method.class)
    assert_equal(@recipient, user.recipient)
    assert_equal(@user_name, user.retriever_method.settings[:user_name])
    assert_equal(@password, user.retriever_method.settings[:password])
  end

  def test_should_create_with_gmail
    user = Rol::User.new do
      retriever_method :gmail, user_name: @user_name,
                               password: @password
    end

    assert_equal(Mail::IMAP, user.retriever_method.class)
    assert_equal('imap.gmail.com', user.retriever_method.settings[:address])
    assert_equal(993, user.retriever_method.settings[:port])
    assert_equal(true, user.retriever_method.settings[:enable_ssl])
    assert_equal(@user_name, user.retriever_method.settings[:user_name])
    assert_equal(@password, user.retriever_method.settings[:password])
  end
end
