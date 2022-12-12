# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Fantasy::Tolkien.unique.character }
    email { Faker::Internet.unique.email }
    password_digest { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)}
  end
end
