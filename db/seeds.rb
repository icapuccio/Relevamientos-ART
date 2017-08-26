# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
user = User.create!(email: 'juan_perez@example.com', password: '12345678', password_confirmation: '12345678')
another_user = User.create!(email: 'don_carlos@example.com', password: '12345678', password_confirmation: '12345678')

#institutions
institution = Institution.create!(name: 'YPF', address:"CARACAS",city:'CAPITAL FEDERAL',province: 'BUENOS AIRES',number: 123, surface:120, workers_count:123, institutions_count:1)
another_institution = Institution.create!(name: 'SHELL', address:"NEUQUEN",city:'CAPITAL FEDERAL',province: 'BUENOS AIRES',number: 532, surface:100, workers_count:123, institutions_count:1)



# Visits
pending_visit = Visit.create!(institution: institution, status: :pending, priority: 1)
assigned_visit = Visit.create!(institution: another_institution, user: user, status: :assigned, priority: 9 )
completed_visit = Visit.create!(institution: institution, user: user, status: :completed, priority: 4 )
completed_visit_another_user = Visit.create!(institution: another_institution, user: another_user, status: :completed, priority: 4 )