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

# Visits
pending_visit = Visit.create!(status: :pending, priority: 1)
assigned_visit = Visit.create!(user: user, status: :assigned, priority: 9 , to_visit_on: Date.today)
completed_visit = Visit.create!(user: user, status: :completed, priority: 4, to_visit_on: Date.yesterday)
completed_visit_another_user = Visit.create!(user: another_user, status: :completed, priority: 4, to_visit_on: Date.yesterday)