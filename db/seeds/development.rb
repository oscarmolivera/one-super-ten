
puts "Seeding tenants..."
load Rails.root.join("db/seeds/tenants.rb")

puts "Seeding categories..."
load Rails.root.join("db/seeds/categories.rb")

puts "Seeding USers..."
load Rails.root.join("db/seeds/users.rb")

puts "Seeding Roles..."
load Rails.root.join("db/seeds/roles.rb")

puts "Seeding Players..."
load Rails.root.join("db/seeds/players.rb")

puts "Seeding Coachs..."
load Rails.root.join("db/seeds/coachs.rb")

puts "Seeding ExternalPlayers..."
load Rails.root.join("db/seeds/external_players.rb")

puts "Seeding Cups & Tournaments..."
load Rails.root.join("db/seeds/cups_and_tournaments.rb")

puts "Seeding SeasonTeams..."
load Rails.root.join("db/seeds/season_teams.rb")

puts "Seeding Matches..."
load Rails.root.join("db/seeds/matches.rb")