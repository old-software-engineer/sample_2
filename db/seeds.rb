# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# find or create to avoid errors when deploying to aws
admin = AdminUser.find_or_initialize_by(email: 'admin@example.com')

if !admin.persisted?
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.save
end

user = User.find_or_initialize_by(email: 'user@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.skip_confirmation!
end

user.save
