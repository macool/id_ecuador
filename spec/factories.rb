require "factory_girl"

CEDULA_VALIDA = "1104680135"
CEDULA_INVALIDA = "1104680134"
RUC_VALIDO = "1104680135001"

FactoryGirl.define do
  factory :user do
    identificacion CEDULA_VALIDA
  end
  factory :user_invalid, class: "User" do
    identificacion CEDULA_INVALIDA
  end
  factory :user_ruc, class: "User" do
    identificacion RUC_VALIDO
  end
end
