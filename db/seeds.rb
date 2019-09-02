# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(email: 'amira@fustany.com', password: 'AmiraAmira', password_confirmation: 'AmiraAmira', first_name: 'Amira', last_name: 'Azzouz')
puts 'Admin created'

Room.create(name: 'Fustany Team')
puts 'Main chat room created'
