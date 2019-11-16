require 'rails_helper'

RSpec.describe "Micropost", type: :system do
  describe 'profile pages' do
    let(:user) {FactoryBot.create(:user)}
    let!(:m1) {FactoryBot.create(:micropost, user: user, content: "Foo")}
    let!(:m2) {FactoryBot.create(:micropost, user: user, content: "Bar")}

    before {
      valid_user(user)
      visit user_path(user)
    }

    it 'should have title' do
      expect(page).to have_title(user.name)
    end

    it 'should have content' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(m1.content)
      expect(page).to have_content(m2.content)
      expect(page).to have_content(user.microposts.count)
    end
  end

  describe 'for signed-in users' do
    let(:user) {FactoryBot.create(:user)}
    before do
      FactoryBot.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryBot.create(:micropost, user: user, content: "Dolor sit amet")
      valid_user(user)
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        expect(page).to have_selector("ol#micropost-#{item.id}", text: item.content)
      end
    end
  end

  describe 'micropost creation' do
    let(:user) {FactoryBot.create(:user)}
    before {
      valid_user(user)
      visit root_path
    }

    describe 'with invalid information' do
      it 'should not create a micropost' do
        expect {
          click_button "Post"
        }.to_not change(Micropost, :count)
      end

      it 'should display error messages' do
        click_button "Post"
        expect(page).to have_content('error')
      end
    end

    describe 'with valid information' do
      it 'should create a micropost' do
        fill_in "micropost_content", with: "Lorem ipsum"
        expect {click_button "Post"}.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    let(:user) {FactoryBot.create(:user)}
    before {
      FactoryBot.create(:micropost, user: user)
      valid_user user
      visit user_path(user)
    }
    it 'should delete a micropost' do
      expect {
        click_link "delete"
        page.driver.browser.switch_to.alert.accept
        visit user_path(user)
      }.to change(Micropost, :count).by(-1)
    end
  end

  describe "micropost search" do
    let(:user) {FactoryBot.create(:user)}
    before do
      @micropost_array = []
      3.times {
        @micropost_array.push(FactoryBot.create(:micropost, user: user))
      }
      valid_user user
      visit user_path(user)
    end

    it "should successfully search" do
      fill_in "search", with: "Lorem ipsum 2"
      click_button "Search"
      expect(page).to have_selector("ol", text: "Lorem ipsum 2")
      @micropost_array.each do |micropost|
        if micropost.content != "Lorem ipsum 2"
          expect(page).to_not have_selector("ol", text: micropost.content)
        end
      end
    end
  end
end
