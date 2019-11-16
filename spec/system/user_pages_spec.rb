require 'rails_helper'

RSpec.describe "User pages", type: :system do
  describe "following/followers" do
    let(:user) {FactoryBot.create(:user)}
    let(:other_user) {FactoryBot.create(:user)}
    before {user.follow(other_user)}

    describe "followed users" do
      before do
        valid_user user
        visit following_user_path(user)
      end

      it 'should have title of Following' do
        expect(page).to have_title('Following')
      end

      it 'should have selector of h3' do
        expect(page).to have_selector('h3', text: 'Following')
      end

      it 'should have link' do
        expect(page).to have_link(other_user.name, href: user_path(other_user))
      end
    end

    describe "followers" do
      before do
        valid_user other_user
        visit followers_user_path(other_user)
      end

      it 'should have title of Followers' do
        expect(page).to have_title('Followers')
      end

      it 'should have selector of h3' do
        expect(page).to have_selector('h3', text: 'Followers')
      end

      it 'should have link' do
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end

  describe "profile page" do
    let(:user) {FactoryBot.create(:user)}

    describe "follow/unfollow buttons" do
      let(:other_user) {FactoryBot.create(:user)}
      before {valid_user user}

      describe "following a user" do
        before {visit user_path(other_user)}

        it "should increment the followed user count" do
          expect {
            click_button "Follow"
            visit user_path(user)
          }.to change {user.following.count}.by(1)
        end

        it "should increment the other user's followers count" do
          expect {
            click_button "Follow"
            visit user_path(other_user)
          }.to change {other_user.followers.count}.by(1)
        end

        describe "toggling the button" do
          before {click_button "Follow"}
          it "should be Unfollow input tag" do
            expect(page).to have_xpath("//input[@value='Unfollow']")
          end
        end
      end

      describe "unfollowing a user" do
        before {
          user.follow(other_user)
          visit user_path(other_user)
        }

        it "should decrement the followed user count" do
          expect {
            click_button "Unfollow"
            visit user_path(user)
          }.to change {user.following.count}.by(-1)
        end

        it "should decrement the other user's followers count" do
          expect {
            click_button "Unfollow"
            visit user_path(other_user)
          }.to change {other_user.followers.count}.by(-1)
        end

        describe "togging the button" do
          before {click_button "Unfollow"}
          it "should be Follow input tag" do
            expect(page).to have_xpath("//input[@value='Follow']")
          end
        end
      end
    end
  end

  describe "index pages" do
    let(:user) {FactoryBot.create(:user)}

    describe "search button" do
      before {
        @users_array = []
        3.times {
          @users_array.push(FactoryBot.create(:user))
        }
        valid_user user
        visit users_path
      }

      it "should successfully search" do
        fill_in "search", with: user.name
        click_button "Search"
        expect(page).to have_selector("li", text: user.name)
        # 検索外のユーザは表示されていないことを確認
        @users_array.each do |user|
          expect(page).to_not have_selector("li", text: user.name)
        end
      end
    end
  end
end
