class UserMailer < ApplicationMailer
    def registration_confirmation(user)
        @user = user
        mail(to: user.email, subject: "Registration Confirmation", from: "no-reply@yourdomain.com")
    end
end
