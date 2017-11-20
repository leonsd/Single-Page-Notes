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

10000.times do |t|
  list = List.new
  list.title = t.odd? ? Faker::DragonBall.character : Faker::OnePiece.character
  list.color = colors[rand(0..5)]
  list.user_id = 1

  rand(2..6).times do |tt|
    list.items.build(description: Faker::Lorem.sentence(3))
  end

  list.save!
end