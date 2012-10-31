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
  end
  factory :contact do
    sequence(:address) { |n| "#{n} rue de la tourte, 69005 Lyon, France" }
    sequence(:first_name) { |n| "Bob Senior #{n}" }
    last_name "Sponge"
    country "France"
    association :emails, factory: :email, strategy: :build
  end
end
