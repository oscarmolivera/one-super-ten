require 'faker'

# For attaching files
include ActionDispatch::TestProcess if defined?(Rails::Console)

# Load tenants and schools
academia = Tenant.find(2)
deportivo = Tenant.find(3)
app_tenants = [academia, deportivo]
tenant_schools = app_tenants.flat_map(&:schools)


image_index = [2,3,4,5,6,7,8]
dice = [true, true, true, false, true, true, true, true, true, true,true, true, true, true, false, true, true, true, true, true]
category_sample = [10,11,12,13]
tenant_schools.each do |school|
  7.times do |i|
    puts "COPA: #{i}"
    filename ="copa#{image_index.sample}.jpg"
    logo_path = Rails.root.join("app/assets/images/#{filename}")
    cup = Cup.create!(
      tenant_id: school.tenant_id,
      name: Faker::Company.industry,
      school_id: school.id,
      description: Faker::Lorem.sentence,
      location: "#{Faker::Locations::Australia.state}, #{Faker::Locations::Australia.location}"             
    )

    # Attach logo to the cup using Active Storage
    cup.logo.attach(
      io: File.open(logo_path),
      filename: filename,
      content_type: "image/jpg"
    )
    5.times do
      rules_content = <<~HTML
        <p><strong>Reglamento oficial:</strong> #{Faker::Lorem.sentence}</p>
        <ul>
          <li>"#{Faker::Lorem.sentence}"</li>
          <li>"#{Faker::Lorem.sentence}"</li>
          <li>"#{Faker::Lorem.sentence}"</li>
        </ul>
      HTML
      tournament_start = Date.new(rand(2024..2026), rand(1..12), rand(1..28))
      tournament_days = [30, 60, 90, 120, 150, 180]
      tournament_ends =tournament_start+tournament_days.sample
      tour = Tournament.create!(
        tenant_id: school.tenant_id,
        name: "Torneo #{cup.name.upcase} - #{tournament_start.year}",
        description: Faker::Lorem.paragraph,
        start_date: tournament_start,
        end_date: tournament_ends,
        public: dice.sample,
        rules: rules_content,
        status: [ 0, 1, 2, 3 ].sample,
        cup_id: cup.id
      )
      tour.category_ids = school.categories.pluck(:id).sample(category_sample.sample)
    end
  end
end