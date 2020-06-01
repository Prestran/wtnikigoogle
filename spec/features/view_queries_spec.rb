require 'rails_helper'

RSpec.describe 'Viewing queries', type: :feature, js: true do
  include Login

  before do
    log_in
  end

  scenario 'single query' do
    query = create(:query, user: User.first)
    create(:query_result, query: query)
    visit query_path(query.id)
    expect(page).to have_content "qwerty"
    expect(all('tr').count).to eq(2)
    expect(page).to have_content('abcabc')
  end
end