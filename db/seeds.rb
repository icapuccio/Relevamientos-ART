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
                              name: 'Pedro', last_name: 'Gonzalez', role: :preventor, address: 'San Nicolás 771, Buenos Aires', zone: west_zone)
another_preventor_user = User.create!(email: 'luis_rodriguez@example.com', password: '12345678', password_confirmation: '12345678',
                                      name: 'Luis', last_name: 'Rodriguez', role: :preventor, address: 'Av del Libertador 6363, Buenos Aires', zone: north_zone)

# Institutions
institution = Institution.create!(name: 'YPF', street: 'Boyacá', city: 'Buenos Aires',
                                  province: 'Buenos Aires', number: 379, surface: 120, workers_count: 123,
                                  institutions_count: 1, activity: 'Estación de Servicio', contract: 'Pepelui',
                                  postal_code: '1406', cuit: '30-12345678-2', phone_number: 45543212, zone: west_zone)
another_institution = Institution.create!(name: 'Shell', street: 'Neuquén', city: 'Buenos Aires',province: 'Buenos Aires',
                                          number: 2329, surface: 100, workers_count: 123, institutions_count: 1,
                                          activity: 'Estación de Servicio', contract: 'Luzbelito', postal_code: '1426',
                                          cuit: '30-12345678-4', phone_number: 45443212, zone: north_zone)

# Visits
pending_visit = Visit.create!(institution: institution, status: :pending, priority: 1)
assigned_visit = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9,
                               to_visit_on: Date.today)
completed_visit = Visit.create!(institution: institution, user: preventor_user, status: :completed, priority: 4,
                                to_visit_on: Date.yesterday, completed_at: Date.yesterday)
completed_visit_another_user = Visit.create!(institution: another_institution, user: another_preventor_user,
                                             status: :completed, priority: 4, to_visit_on: Date.yesterday,
                                             completed_at: Date.yesterday, observations: 'Se observa humedad en el area de trabajo')

#Visits and tasks CAP
assigned_visit_cap = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9,
                                   to_visit_on: Date.today)
pending_visit_cap = Visit.create!(institution: institution, status: :pending, priority: 8)
assigned_visit_cap_2 = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9,
                                     to_visit_on: Date.today)

completed_cap_task = Task.create!(task_type: :cap, status: :pending, visit: assigned_visit_cap )
cap_result = CapResult.create!(task: completed_cap_task, topic: 'Optimización de Salidas de emergencia' )
Attendee.create!(name:'Julian', last_name:'Alvarez', cuil:'23-12345621-6', sector: 'Seguridad e higiene', cap_result: cap_result)
completed_cap_task.complete(DateTime.yesterday)

completed_cap_task_2 = Task.create!(task_type: :cap, status: :pending, visit: assigned_visit_cap_2 )
cap_result_2 = CapResult.create!(task: completed_cap_task_2, topic: 'Como aprobar proyecto?' )
Attendee.create!(name:'Tomas', last_name:'Capuccio', cuil:'23-123235621-6', sector: '5to año utn frba', cap_result: cap_result_2)
completed_cap_task_2.complete(DateTime.yesterday)

Task.create!(task_type: :cap, status: :pending, visit: pending_visit_cap )

#Visits and tasks RAR
assigned_visit_rar = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 20,
                                   to_visit_on: Date.today)
pending_visit_rar = Visit.create!(institution: institution, status: :pending, priority: 8)
assigned_visit_rar_2 = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9,
                                     to_visit_on: Date.today)

completed_rar_task = Task.create!(task_type: :rar, status: :pending, visit: assigned_visit_rar )
rar_result = RarResult.create!(task: completed_rar_task, topic: 'Minería' )
Worker.create!(name:'Julian', last_name:'Alvarez', cuil:'23-12345621-6', sector: 'Seguridad e higiene', rar_result: rar_result)
completed_rar_task.complete(DateTime.yesterday)

completed_rar_task_2 = Task.create!(task_type: :rar, status: :pending, visit: assigned_visit_rar_2 )
rar_result_2 = RarResult.create!(task: completed_rar_task_2, topic: 'Trabajadores en mina 5' )
worker_1 = Worker.create!(name:'Tomas', last_name:'Capuccio', cuil:'23-123235621-6', sector: 'minero', rar_result: rar_result_2)
Risk.create!(description:'derrumbe', worker: worker_1)
completed_rar_task_2.complete(DateTime.yesterday)
Task.create!(task_type: :rar, status: :pending, visit: pending_visit_rar )

# Visits and Tasks rgrl
assigned_visit_rgrl = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 20,
                                   to_visit_on: Date.today)
pending_visit_rgrl = Visit.create!(institution: institution, status: :pending, priority: 8)
assigned_visit_rgrl_2 = Visit.create!(institution: institution, user: preventor_user, status: :assigned, priority: 9,
                                     to_visit_on: Date.today)

completed_rgrl_task = Task.create!(task_type: :rgrl, status: :pending, visit: assigned_visit_rgrl )
rgrl_result = RgrlResult.create!(task: completed_rgrl_task )
Question.create!(description:'Quien soy', answer:'El Junior de la muelte', category: 'Maniiiel', rgrl_result: rgrl_result)

completed_rgrl_task.complete(DateTime.yesterday)

completed_rgrl_task_2 = Task.create!(task_type: :rgrl, status: :pending, visit: assigned_visit_rgrl_2 )
rgrl_result_2 = RgrlResult.create!(task: completed_rgrl_task_2)
Question.create!(description:'quien es el mas poronga en este conventillo del orto', answer:'yo soy el mas poronga', category: 'okupas', rgrl_result: rgrl_result_2)
completed_rgrl_task_2.complete(DateTime.yesterday)
Task.create!(task_type: :rgrl, status: :pending, visit: pending_visit_rgrl )

