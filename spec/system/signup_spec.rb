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

  it "mail" do
    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "Account activation"
    end
  end
end
