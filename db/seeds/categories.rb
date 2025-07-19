academia = Tenant.find(2)
deportivo = Tenant.find(3)

School.create!(tenant: academia, name:'Futbol Campo', description: 'Escuela de Valores')
School.create!(tenant: academia, name:'Futbol Sala', description: 'Escuela de Valores')
emas= School.create!(tenant: deportivo, name:'Escuela Masculina', description: 'Futbol Campo de Varones')
efem = School.create!(tenant: deportivo, name:'Escuela Femenina', description: 'Futbol Campo de Mujeres')
match_duration = {6 => 20, 7 => 40, 8 => 40, 9 => 50, 10 => 50, 11 => 60, 12 => 60, 13 => 60, 14 => 70, 15 => 70, 16 => 80, 17 => 90, 18 => 90}
School.where(tenant: academia).each do |school|
  (1..13).each do |i|
    category = Category.create!(
      tenant: academia,
      school: school,
      name: "Sub #{i + 5}",
      slug: "sub_#{i + 5}",
      description: "Niños, Niñas o jovenes y señoritas menores de #{i + 5} años",
    )
    CategoryRule.create!(
      category_id: category.id,
      key: "category_match_duration",
      value: set_match_duration = match_duration[i + 5]
    )
  end
end

School.where(id: emas.id).each do |school|
  (1..13).each do |i|
    category = Category.create!(
      tenant: deportivo,
      school: school,
      name: "Chamos_Sub #{i + 5}",
      slug: "sub_#{i + 5}",
      description: "Niños menores de #{i + 5} años",
    )
    CategoryRule.create!(
      category_id: category.id,
      key: "category_match_duration",
      value: set_match_duration = match_duration[i + 5]
    )
  end
end

School.where(id: efem.id).each do |school|
  (1..13).each do |i|
    category = Category.create!(
      tenant: deportivo,
      school: school,
      name: "Chamas_Sub #{i + 5}",
      slug: "sub_#{i + 5}",
      description: "Niñas menores de #{i + 5} años",
    )
    CategoryRule.create!(
      category_id: category.id,
      key: "category_match_duration",
      value: set_match_duration = match_duration[i + 5]
    )
  end
end