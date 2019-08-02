require 'rails_helper'

RSpec.describe "User edit", type: :system do
  let(:user) { FactoryBot.create(:user) }

  # ユーザは編集に成功するテスト
  # フレンドリーフォワーディングテスト
  # ログインしていないユーザがログイン後、アクセスしようとしたページにリダイレクトすること
  it "successful edit" do
    visit user_path(user)
    valid_user(user)
    click_link "Account"
    click_link "Setting"

    fill_in "Email", with: "edit@example.com"
    click_button "Save changes"

    expect(current_path).to eq user_path(user)
  end

  # ユーザの編集に失敗するテスト
  it "unsuccessful edit" do
    valid_user(user)
    visit user_path(user)
    click_link "Account"
    click_link "Setting"

    fill_in "Email", with: "foo@invalid"
    fill_in "Password", with: "foo", match: :first
    fill_in "Confirmation", with: "bar"
    click_button "Save change"

    expect(user.reload.email).to_not eq "foo@invalid"
  end

end
