# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def welcome_email
        user=user.first
        UserMailer.registration_confirmation(user)
    end
end
