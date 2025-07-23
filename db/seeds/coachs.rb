require 'faker'
co_aca = User.find_by(email: "entrenador@academy1.com")
co_dep = User.find_by(email: "entrenador@academy2.com")
academia = Tenant.find_by(subdomain: "academia-margarita")

CoachProfile.create!( user: co_aca, hire_date: rand(2..5).years.ago, salary: rand(1500..3000))
CoachProfile.create!( user: co_dep, hire_date: rand(2..5).years.ago, salary: rand(1500..3000))

# Create demo Coaches
10.times do |i|
  coach_name = Faker::Name.first_name_men
  coach_surname = Faker::Name.last_name
  user = User.create!(
    email: "#{(coach_name).downcase}.#{(coach_surname).downcase}#{i}@academia.com",
    password: "s3cret.",
    first_name: coach_name,
    last_name: coach_surname,
    tenant_id: academia.id
  )
  user.add_role(:coach, academia)

  CoachProfile.create!(
    user: user,
    hire_date: rand(2..5).years.ago,
    salary: rand(1500..3000)
  )

  # Create demo Assistant Coaches
  3.times do |i|
    coach_assist_name = Faker::Name.first_name_men
    coach_assist_surname = Faker::Name.last_name
    user = User.create!(
      email: "#{(coach_assist_name).downcase}.#{(coach_assist_surname).downcase}#{i}@academia.com",
      password: "s3cret.",
      first_name: coach_assist_name,
      last_name: coach_assist_surname,
      tenant_id: academia.id
    )
    user.add_role(:assistant_coach, academia) 
  end
end

# Assign Assistants to Coaches randomly
CoachProfile.all.each do |coach_profile|
  coach = coach_profile.user
  assistants = User.with_role(:assistant_coach, academia).sample(2)
  assistants.each do |assistant|
    AssistantAssignment.create!(coach: coach, assistant: assistant)
  end
end