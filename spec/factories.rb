require "factory_girl"

FactoryGirl.define do
  factory :user do
    identificacion "1104680135"
  end
  factory :user_invalid, class: "User" do
    identificacion "1104680134"
  end
  factory :user_ruc, class: "User" do
    identificacion "1104680135001"
  end
end
