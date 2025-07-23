
puts "Seeding tenants..."
load Rails.root.join("db/seeds/tenants.rb")

puts "Seeding categories..."
load Rails.root.join("db/seeds/categories.rb")

puts "Seeding USers..."
load Rails.root.join("db/seeds/users.rb")

puts "Seeding Roles..."
load Rails.root.join("db/seeds/roles.rb")

