# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content "hahaha hohoho"
    author_id {BSON::ObjectId.new}
    item_id {BSON::ObjectId.new}
  end
end
