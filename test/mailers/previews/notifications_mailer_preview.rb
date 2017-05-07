# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/signup
  def signup
    NotificationsMailer.signup(User.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/home_added
  def home_added
    NotificationsMailer.home_added(Home.last)
  end

end
