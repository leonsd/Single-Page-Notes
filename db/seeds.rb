# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
colors = [
            'blue lighten-3',
            'green lighten-2',
            'red lighten-3',
            'indigo lighten-2',
            'white',
            'yellow'
         ]

user = User.create(email: 'leon.sdsilva@gmail.com', password: '123456', password_confirmation: '123456');
user = User.create(email: 'luan.patrick@gmail.com', password: '123456', password_confirmation: '123456');
user = User.create(email: 'vagner.grizoste@gmail.com', password: '123456', password_confirmation: '123456');

100000.times do |t|
  list = List.new
  list.title = t.odd? ? Faker::DragonBall.character : Faker::OnePiece.character
  list.color = colors[rand(0..5)]
  list.user_id = rand(1..3)

  rand(2..5).times do |tt|
    list.items.build(description: Faker::Lorem.sentence(3))
  end

  list.save!
end