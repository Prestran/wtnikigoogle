require 'rails_helper'
include Login

RSpec.describe 'Creating a query', type: :feature, js: true do
  before do
    log_in
  end

  scenario 'valid inputs' do
    visit new_query_path
    fill_in 'Name', with: 'warhammer'
    click_on 'Submit'
    page.accept_alert
    visit queries_path
    expect(page).to have_content 'warhammer'
  end

  scenario 'invalid inputs' do
    visit new_query_path
    click_on 'Submit'
    page.accept_alert "Name: can't be blank"
    expect(page).to have_content 'Enter searched phrase:'
  end
end