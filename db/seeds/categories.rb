academia = Tenant.find(2)
deportivo = Tenant.find(3)

School.create!(tenant: academia, name:'Futbol Campo', description: 'Escuela de Valores')
School.create!(tenant: academia, name:'Futbol Sala', description: 'Escuela de Valores')
emas= School.create!(tenant: deportivo, name:'Escuela Masculina', description: 'Futbol Campo de Varones')
efem = School.create!(tenant: deportivo, name:'Escuela Femenina', description: 'Futbol Campo de Mujeres')

School.where(tenant: academia).each do |school|
  (1..13).each do |i|
    Category.create!(
      tenant: academia,
      school: school,
      name: "Sub #{i + 5}",
      description: "Niños o niñas de #{i + 6} a #{i + 7} años",
    )
  end
end

School.where(id: emas.id).each do |school|
  (1..13).each do |i|
    Category.create!(
      tenant: deportivo,
      school: school,
      name: "Chamos_Sub #{i + 5}",
      description: "Niños de #{i + 6} a #{i + 7} años",
    )
  end
end

School.where(id: efem.id).each do |school|
  (1..13).each do |i|
    Category.create!(
      tenant: deportivo,
      school: school,
      name: "Chamas_Sub #{i + 5}",
      description: "Niños de #{i + 6} a #{i + 7} años",
    )
  end
end