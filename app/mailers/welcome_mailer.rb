class WelcomeMailer < ActionMailer::Base
  default from: "alexandre@gogoreco.com"

  def welcome_user(user)
    @firstname = user.firstname || ""
    mail(
      to: user.email,
      subject: "Gogoreco, Bienvenue ! Comment s'est passé ta visite ?",
    )
  end
end
