# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Active Admin Users
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# Zones
west_zone = Zone.create!(name: 'Oeste')
north_zone = Zone.create!(name: 'Norte')

# Users
admin_user = User.create!(email: 'juan_perez@example.com', password: '12345678', password_confirmation: '12345678',
                          name: 'Juan', last_name: 'Perez', role: :admin)
backoffice_user = User.create!(email: 'jose_gomez@example.com', password: '12345678', password_confirmation: '12345678',
                               name: 'Jose', last_name: 'Perez', role: :backoffice)
preventor_user = User.create!(email: 'pedro_gonzalez@example.com', password: '12345678', password_confirmation: '12345678',
                              name: 'Pedro', last_name: 'Gonzalez', role: :preventor, latitude: -34.6246152, longitude: -58.4815459, zone: west_zone)
another_preventor_user = User.create!(email: 'luis_rodriguez@example.com', password: '12345678', password_confirmation: '12345678',
                                      name: 'Luis', last_name: 'Rodriguez', role: :preventor, latitude: -34.6215814, longitude: -58.4815459, zone: north_zone)

# Institutions
institution = Institution.create!(name: 'YPF', address:"CARACAS", city:'CAPITAL FEDERAL',
                                  province: 'BUENOS AIRES', number: 123, surface:120, workers_count:123,
                                  institutions_count:1, activity: 'ESTACION DE SERVICIO', contract: 'PEPELUI',
                                  postal_code: '1406', cuit: '30-12345678-2', phone_number: 45543212, latitude: 1.12345, longitude: 4.123456, zone: west_zone)
another_institution = Institution.create!(name: 'SHELL', address:"NEUQUEN",city:'CAPITAL FEDERAL',province: 'BUENOS AIRES',
                                          number: 532, surface:100, workers_count:123, institutions_count:1,
                                          activity: 'ESTACION DE SERVICIO', contract: 'LUZBELITO', postal_code: '1426',
                                          cuit: '30-12345678-4', phone_number: 45443212, latitude: 2.12345, longitude: 3.123456, zone: north_zone)

# Visits
pending_visit = Visit.create!(institution: institution, status: :pending, priority: 1)
assigned_visit = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9, to_visit_on: Date.today)
completed_visit = Visit.create!(institution: institution, user: preventor_user, status: :completed, priority: 4, to_visit_on: Date.yesterday)
completed_visit_another_user = Visit.create!(institution: another_institution, user: another_preventor_user, status: :completed, priority: 4, to_visit_on: Date.yesterday)

# Tasks
Task.create!(task_type: :rgrl, status: :pending, visit: pending_visit )
Task.create!(task_type: :rgrl, status: :pending, visit: assigned_visit )
Task.create!(task_type: :cap, status: :completed, completed_at:Date.yesterday,  visit: completed_visit )
Task.create!(task_type: :rgrl, status: :completed, completed_at:Date.yesterday, visit: completed_visit )
Task.create!(task_type: :rgrl, status: :completed, completed_at:Date.yesterday, visit: completed_visit_another_user )
Task.create!(task_type: :cap, status: :completed, completed_at:Date.yesterday, visit: completed_visit_another_user )