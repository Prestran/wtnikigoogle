FactoryBot.define do
  factory :user do
    email { 'admin@email.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end