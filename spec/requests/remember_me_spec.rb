require 'rails_helper'

RSpec.describe "Remember Me", type: :request do
  let(:user){
    FactoryBot.create(:user)
  }

  # 2つのブラウザで同じユーザがログアウトすると、エラーが起きるテスト
  context "with valid information" do
    it "logs in with valid information followed by logout" do
      sign_in_as user
      expect(response).to redirect_to user_path(user)

      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil

      # 別のウィンドウでログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end

  # remember_meのチェックボックスのテスト
  context "login with remembering" do
    it "remembers cookies" do
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                             remember_me: '1'} }
      expect(response.cookies[:remember_token]).to_not eq nil
    end
  end

  context "login without remembering" do
    it "doesn't remember cookies" do
      # クッキーを保存してログイン
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                            remember_me: ' 1'} }
      delete logout_path
      # クッキーを保存せずにログイン
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                            remember_me: '0'} }
      expect(response.cookies[:remember_token]).to eq nil
    end
  end
end
