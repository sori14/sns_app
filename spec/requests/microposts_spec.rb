require 'rails_helper'

RSpec.describe "Micropost", type: :request do
  describe 'in the Microposts controller' do
    it 'submitting to the create action' do
      post microposts_path
      expect(response).to redirect_to login_path
    end

    it 'submitting to the destroy action' do
      delete micropost_path(FactoryBot.create(:micropost))
      expect(response).to redirect_to login_path
    end
  end
end
