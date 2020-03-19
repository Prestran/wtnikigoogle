FactoryBot.define do
  factory :query_result do
    query
    text { 'abcabc' }
    uri { 'https://google.com' }
  end
end