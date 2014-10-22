# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :evaluation do
    author_id {BSON::ObjectId.new}
    item_id {BSON::ObjectId.new}
    score 3
  end
end
