require 'rails_helper'

RSpec.describe "User sign up", type: :system do
  it "user sign up" do
    visit root_path
    click_link "Sign up now!"
    fill_in 'Name', with: "Example User"
    fill_in 'Email', with: "test@example.com"
    fill_in 'Password', with: "test1234"
    fill_in 'Confirmation', with: "test1234"
    click_button "Create my account"
    expect(page).to have_content "Please check your email to activate your account"
    expect(current_path).to eq root_path
  end
end
