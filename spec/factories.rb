# require 'factory_girl'
# FactoryGirl.find_definitions

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "foo_#{n}" }
    password "foobar"
    email { "#{username}@bar.com" }
    role "admin"

    #factory :admin do
      #admin true
    #end
  end

  factory :email do
    sequence(:address) { |n| "foo_#{n}_bar@example.com"}
    contact
  end

  factory :contact do
    sequence(:address) { |n| "#{n} rue de la tourte, 69005 Lyon, France" }
    sequence(:first_name) { |n| "Bob #{n} Junior" }
    sequence(:company) {|n| "Batman Inc. #{n}"}
    civility "Mr"
    last_name "Sponge"
    country "France"

    factory :contact_with_emails do
      after(:create) do |contact, evaluator|
        create_list(:email, rand(1..4), contact: contact, contact_id: contact.id)
      end
    end
  end
end
