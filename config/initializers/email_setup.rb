ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'relevamientos-art.herokuapp.com',
    user_name:            'relevamientosdigitales@gmail.com',
    password:             'Contrasena1',
    authentication:       'plain',
    enable_starttls_auto: true
}