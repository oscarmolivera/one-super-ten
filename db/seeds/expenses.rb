require 'faker'

academia = Tenant.find_by(subdomain: "academia-margarita") || Tenant.first
AUTHORS = academia.users.to_a

EXPENSE_TYPES = Expense.expense_types.keys
PAYMENT_METHODS = %w[cash bank_transfer credit_card cheque paypal]

puts "🌱 Generating 150 fake expenses for #{academia.name}..."

150.times do
  author = AUTHORS.sample

  expensable_options = [
    User.where(tenant: academia).sample,
    Event.where(tenant: academia).sample,
    nil
  ].compact

  expensable = expensable_options.sample

academia.expenses.create!(
    author: author,
    title: Faker::Company.bs.titleize,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    amount: rand(20.0..5000.0).round(2),
    spent_on: Faker::Date.between(from: 90.days.ago, to: Date.today),
    expense_type: EXPENSE_TYPES.sample,
    payment_method: PAYMENT_METHODS.sample,
    reference_code: Faker::Invoice.reference,
    expensable: expensable
  )

  print "."
end

puts "\n✅ Done creating 150 expenses!"