require 'test_helper'

class NotificationsMailerTest < ActionMailer::TestCase
  test "signup" do
    mail = NotificationsMailer.signup
    assert_equal "Signup", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "home_added" do
    mail = NotificationsMailer.home_added
    assert_equal "Home added", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
