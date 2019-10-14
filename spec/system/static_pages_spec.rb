require 'rails_helper'

RSpec.describe "Static pages", type: :system do
  describe 'Home page' do
    describe 'for sined-in users' do
      let(:user) {FactoryBot.create(:user)}
      before do
        FactoryBot.create(:micropost, user: user, content: "Lorem")
        FactoryBot.create(:micropost, user: user, content: "Ipsum")
        valid_user(user)
        visit root_path
      end
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("ol#micropost-#{item.id}", text: item.content)
        end
      end

      describe 'follower/following counts' do
        let(:other_user) {FactoryBot.create(:user)}
        before do
          other_user.follow(user)
          visit root_path
        end

        it 'should not increase following' do
          expect(page).to have_link("0 following", href: following_user_path(user))
        end

        it 'should increase followers' do
          expect(page).to have_link("1 followers", href: followers_user_path(user))
        end
      end
    end
  end
end
