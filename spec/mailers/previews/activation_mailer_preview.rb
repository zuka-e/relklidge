# Preview all emails at http://localhost:3000/rails/mailers/activation_mailer
class ActivationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/activation_mailer/activation
  def activation
    user = User.first # テスト用
    user.activation_token = SecureRandom.urlsafe_base64
    user.update_attribute(:activation_digest, User.digest(user.activation_token))
    ActivationMailer.activation(user) # mailers/activation_mailer.rb
  end

  # Preview this email at http://localhost:3000/rails/mailers/activation_mailer/password_reset
  def password_reset
    ActivationMailer.password_reset
  end

end
