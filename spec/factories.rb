# require 'factory_girl'
# FactoryGirl.find_definitions

FactoryGirl.define do
  factory :user do
    #sequence(:username) { |n| "foo_#{n}" }
    username { Faker::Internet.user_name }
    password { SecureRandom.urlsafe_base64[0..15] }
    email { Faker::Internet.email }
    role "admin"

    factory :admin, class: User do
      role     "administrator"
    end

    factory :simple_user, class: User do
      role     "user"
    end
  end

  factory :delivery_request do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address}
    postal_code { Faker::Address.zip }
    city { Faker::Address.city }
    country "France"
    reason_of_disposal "Other"
    module_count { rand(1..49)}
    modules_condition "Intact"
    length 160
    width  100
    height 120
    weight 800
    pallets_number 4

  end
  factory :member do
    user_name       { Faker::Internet.user_name }
    company         { Faker::Company.name }
    web_profile_url { Faker::Internet.url }
    address         { "#{Faker::Address.street_address} #{Faker::Address.street_suffix}" }
    city            { Faker::Address.city }
    postal_code     { Faker::Address.zip }

    sequence(:start_date) { |n| n.weeks.ago }

    activity_list   "Manufacturer"
    country         "France"
    category        "C"
  end

  factory :email do
    #sequence(:address) { |n| "foo_#{n}_bar@example.com"}
    address { Faker::Internet.email }
    contact
  end

  factory :contact do
    address { "#{Faker::Address.street_address} #{Faker::Address.street_suffix}" }
    first_name { Faker::Name.first_name }
    company { Faker::Company.name }
    civility "Undef"
    last_name { Faker::Name.last_name}
    country "France"

    factory :contact_with_emails do
      after(:create) do |contact, evaluator|
        create_list(:email, rand(1..4), contact: contact, contact_id: contact.id)
      end
    end
  end
end
