require 'rails_helper'

RSpec.describe "User login", type: :system do
  let(:user) {
    FactoryBot.create(:user)
  }

  it "user successfully login" do
    valid_user(user)
    expect(current_path).to eq user_path(user)
    expect(page).to_not eq have_content "Log in"
  end

  it "user doesn't login with invalid information" do
    visit root_path
    click_link "Log in"
    fill_in "Email", with: ""
    fill_in "Password", with: ""
    click_button "Log in"

    expect(current_path).to eq login_path
    expect(page).to have_content "Log in"
    expect(page).to have_content "Invalid email/password combination"
  end

  it "user logout" do
    valid_user(user)
    click_link "Account"
    click_link "Log out"
    expect(current_path).to eq root_path
    expect(page).to have_content "Log in"
  end

end
