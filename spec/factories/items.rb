# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    name "best course in da place"
    school_ids {[BSON::ObjectId.new]}
  end
end
