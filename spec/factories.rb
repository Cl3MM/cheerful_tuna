# require 'factory_girl'
# FactoryGirl.find_definitions

FactoryGirl.define do

  FAKE_REAL_ADDRESSES = {
                          clem:   {address: "43 avenue Lanessan", postal_code: "69410", city: "Champagne au mont d'or", country: "France"},
                          nico:   {address: "96 rue Raymond Losserand", postal_code: "75014", city: "Paris", country: "France"},
                          sandy:  {address: "3 rue saint antoine", postal_code: "69003", city: "Lyon", country: "France"},
                          mum:    {address: "10 rue de l'hopital", postal_code: "69240", city: "Bourg de Thizy", country: "France"}
  }
  factory :user do
    #sequence(:username) { |n| "foo_#{n}" }
    username { Faker::Internet.user_name }
    password { SecureRandom.urlsafe_base64[0..15] }
    email { Faker::Internet.email }

    factory :admin, class: User do
      role     "administrator"
    end

    factory :simple_user, class: User do
      role     "user"
    end
  end

#require 'faker'
#require 'factory_girl'
#FactoryGirl.find_definitions
#DeliveryRequest.all.map(&:destroy)
#6.times{FactoryGirl.create(:delivery_request)}

  factory :delivery_request do
    fake_address              = FAKE_REAL_ADDRESSES.keys.sample
    fake_address              = FAKE_REAL_ADDRESSES[fake_address]

    name                      { Faker::Name.name }
    email                     "clement.roullet@ceres-recycle.org" #{ Faker::Internet.email }
    user_ip                   { Faker::Internet.ip_v4_address }
    #address                   { Faker::Address.street_address}
    #postal_code               { Faker::Address.zip }
    #city                      { Faker::Address.city }
    #country                   { COUNTRIES.sample }
    address                   { fake_address[:address] }
    postal_code               { fake_address[:postal_code] }
    city                      { fake_address[:city] }
    country                   { fake_address[:country] }
    module_count              { rand(1..49).to_s}
    manufacturers             { Faker::Company.name }
    length                    { rand(80..160).to_s }
    width                     { rand(80..160).to_s }
    height                    { rand(80..160).to_s }
    weight                    { rand(80..160).to_s }
    pallets_number            { rand(1..10).to_s }
    modules_production_year   { rand(1990..2012).to_s }
    technology                { DeliveryRequest.delivery_requests_technologies.keys.sample }
    reason_of_disposal        { DeliveryRequest.delivery_requests_reason_of_disposal.sample }
    modules_condition         { DeliveryRequest.delivery_requests_modules_condition.sample }
    user_agent          "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11"
    referer             "http:www.google.fr"
  end

  factory :member do
    user_name       { Faker::Internet.user_name }
    company         { Faker::Company.name }
    web_profile_url { Faker::Internet.url }
    address         { "#{Faker::Address.street_address} #{Faker::Address.street_suffix}" }
    city            { Faker::Address.city }
    postal_code     { Faker::Address.zip }

    sequence(:start_date) { |n| n.weeks.ago }

    activity_list   { %w(Manufacturer Producer Distributor Installer).sample }
    country         { COUNTRIES.sample }
    category        { %w(A B C D Free).sample }
  end

  factory :email do
    #sequence(:address) { |n| "foo_#{n}_bar@example.com"}
    address { Faker::Internet.email }
    contact
  end

  factory :contact do
    address     { "#{Faker::Address.street_address} #{Faker::Address.street_suffix}" }
    first_name  { Faker::Name.first_name }
    company     { Faker::Company.name }
    civility    { %w[Undef Mr Mrs Ms Dr].sample }
    last_name   { Faker::Name.last_name}
    country     { COUNTRIES.sample }

    after(:build) do |contact|
      rand(1..6).times do
        contact.emails << build(:email, contact: contact)
      end
    end
    #factory :contact_with_emails do
      #after(:create) do |contact, evaluator|
        #create_list(:email, rand(1..4), contact: contact, contact_id: contact.id)
      #end
    #end
  end

  factory :html_snippet do
    name        "delivery_request_help"
    snippets    "<h3>Online help</h3>
<p>Please fill in the required fields.</p>
<p>The form will be transmitted to the closest collection point who will contact you to arrange the delivery.</p>
<p>You will receive a confirmation email with the next steps.</p>"
    view_path   "delivery_requests/new"
  end

end
