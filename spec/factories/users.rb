FactoryBot.define do
  factory :user do
    nickname              {"ヤマ"}
    email                 {"aaaa@gmail.com"}
    password              {"aaaa111"}
    first_name            {"太郎"}
    family_name             {"山田"}
    first_name_kana       {"タロウ"}
    family_name_kana        {"ヤマダ"}
    birthday              {"2000/01/01"}
  end
end