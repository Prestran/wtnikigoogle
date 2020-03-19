# frozen_string_literal: true

module Login
  def log_in
    FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: 'admin@email.com'
    fill_in 'user[password]', with: 'password123'
    click_on 'commit'
    visit root_path
  end
end

