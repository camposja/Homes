class NotificationsMailer < ApplicationMailer
  default from: "hello@TinyEstates.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.signup.subject
  #
  def signup(user_that_just_signed_up)
    mail to: user_that_just_signed_up.name,
         subject: "You signed up for Tiny Estates"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.home_added.subject
  #
  def home_added(home)
    @home = home

    mail subject: "New home available in | Tiny Estates|",
              to: "to@example.org"
  end
end
