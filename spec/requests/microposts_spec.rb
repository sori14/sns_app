require 'rails_helper'

RSpec.describe "Micropost", type: :request do
  describe 'in the Microposts controller' do
    describe "submitting to the create action" do
      before {post microposts_path}

      it "should redirect login_path" do
        expect(response).to redirect_to login_path
      end
    end

    describe "submitting to the destroy action" do
      before {delete micropost_path(FactoryBot.create(:micropost))}

      it "should redirect login_path" do
        expect(response).to redirect_to login_path
      end
    end
  end
end
