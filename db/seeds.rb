# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Active Admin Users
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
AdminUser.create!(email: 'juan_perez@example.com', password: '12345678', password_confirmation: '12345678')

# Users
admin_user = User.create!(email: 'juan_perez@example.com', password: '12345678', password_confirmation: '12345678',
                          name: 'Juan', last_name: 'Perez', role: :admin)
backoffice_user = User.create!(email: 'jose_gomez@example.com', password: '12345678', password_confirmation: '12345678',
                               name: 'Jose', last_name: 'Perez', role: :backoffice)
preventor_user = User.create!(email: 'pedro_gonzalez@example.com', password: '12345678', password_confirmation: '12345678',
                              name: 'Pedro', last_name: 'Gonzalez', role: :preventor, latitude: -34.6246152, longitude: -58.4815459)
another_preventor_user = User.create!(email: 'luis_rodriguez@example.com', password: '12345678', password_confirmation: '12345678',
                                      name: 'Luis', last_name: 'Rodriguez', role: :preventor, latitude: -34.6215814, longitude: -58.4815459)

# Visits
pending_visit = Visit.create!(status: :pending, priority: 1)
assigned_visit = Visit.create!(user: preventor_user, status: :assigned, priority: 9)
completed_visit = Visit.create!(user: preventor_user, status: :completed, priority: 4)
completed_visit_another_user = Visit.create!(user: another_preventor_user, status: :completed, priority: 4)
