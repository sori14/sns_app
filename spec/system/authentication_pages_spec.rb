require 'rails_helper'

RSpec.describe "Authentication", type: :system do
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) {FactoryBot.create(:user)}

      describe "in the Users controller" do

        describe "visiting the following page" do
          before {visit following_user_path(user)}

          it "should have title of 'Log in'" do
            expect(page).to have_title('Log in')
          end
        end

        describe "visiting the followers page" do
          before {visit followers_user_path(user)}

          it "should have title of 'Log in'" do
            expect(page).to have_title('Log in')
          end
        end
      end

      describe "in the Relationships controller" do

        describe "submitting to the create action" do
          before {post relationships_url}

          it "should redirect login_url" do
            expect(response).to redirect_to(login_url)
          end
        end

        describe "submitting to the destroy action" do
          before { delete relationship_url(1)}

          it "should redirect login_url" do
            expect(response).to redirect_to(login_url)
          end
        end
      end
    end
  end
end
