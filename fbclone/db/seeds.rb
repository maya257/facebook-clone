# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

10.times do 
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'test123',
    birth_date: Faker::Date.birthday,
    gender: Faker::Gender.binary_type
  )
end


puts 'Created 10 users!'

NotificationType.create!(name: 'post_comment')
NotificationType.create!(name: 'post_like')

Post.create!(user_id: User.first.id, message: 'Testing posts')
Post.create!(user_id: User.last.id, message: 'Testing posts 2')

Comment.create!(user_id: User.last.id, post_id: Post.first.id, message: 'Another comment')
Comment.create!(user_id: User.first.id, post_id: Post.last.id, message: 'Another comment')

Like.create!(user_id: User.last.id, post_id: Post.first.id)
Like.create!(user_id: User.first.id, post_id: Post.last.id)
