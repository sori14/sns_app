require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  #表示内容の確認
  render_views

  #インスタンス変数ではなく、let変数にする
  let(:base_title) { 'SNS' }

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
      assert_select "title", "Home | #{base_title}"
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | #{base_title}"
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
      assert_select "title", "About | #{base_title}"
    end
  end

  describe "GET #contact" do
    it "return http success" do
      get :contact
      expect(response).to have_http_status(:success)
      assert_select "title", "Contact | #{base_title}"
    end
  end

end
