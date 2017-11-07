class WelcomeMailer < ApplicationMailer
  def welcome_send(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Bienvenido')
  end

  def reset_password_send(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Nueva Contraseña')
  end
end
