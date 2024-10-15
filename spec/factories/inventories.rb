FactoryBot.define do
  factory :inventory do
    quantity { 1 }
    price { "9.99" }
    name { "MyString" }
    description { "MyString" }
    category { "MyString" }
    photo_path { "MyString" }
  end
end
