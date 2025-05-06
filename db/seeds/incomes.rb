require 'faker'
academia = Tenant.find_by(subdomain: "academia-margarita")
income_types = %w[monthly_payment product_sale sponsor investment other]
tags = (1..10).map { |i| "cat-#{i.to_s.rjust(2, '0')}" }

150.times do
  type = income_types.sample

  title =
    case type
    when "monthly_payment"
      "#{Faker::Name.name} Mensualidad"
    when "product_sale"
      "Venta: #{Faker::Commerce.product_name}"
    when "sponsor"
      "Aporte Patrocinador: #{Faker::Company.name}"
    when "investment"
      "Inversión ángel: #{Faker::Name.name}"
    else
      "Ingreso Diverso: #{Faker::Lorem.word.capitalize}"
    end

  academia.incomes.create!(
    title: title,
    description: Faker::Lorem.sentence(word_count: 6),
    amount: Faker::Commerce.price(range: 10.0..500.0),
    income_type: type,
    received_at: Faker::Date.between(from: 3.months.ago, to: Date.today),
    tag: tags.sample
  )
end