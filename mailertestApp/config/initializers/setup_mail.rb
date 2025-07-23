ActionMailer::Base.smtp_settings = {
  address:              "smtp.gmail.com",
  port:                 587,
  domain:               "gmail.com",
  user_name: Rails.application.credentials.dig(:smtp, :user_name),
  password:  Rails.application.credentials.dig(:smtp, :password),
  authentication:       "plain",
  enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
