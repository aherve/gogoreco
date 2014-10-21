class SignupPermissionMailer < ActionMailer::Base
  default from: "team@gogoreco.com"

  def send_user_email(email,school_names)
    @user_email = email
    @schools = school_names.join(", ")
    mail(
      to: email,
      subject: "Invitation sur Gogoreco",
    )
  end


end
