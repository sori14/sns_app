require 'rails_helper'

RSpec.describe "Password reset", type: :request do
  let(:user) {FactoryBot.create(:user)}

  include ActiveJob::TestHelper

  describe 'resets password' do
    it 'Invalid email should fail' do
      perform_enqueued_jobs do
        post password_resets_path, params: {password_reset: {email: ""}}
        expect(response).to render_template(:new)
      end
    end

    it 'Valid email should succeed' do
      perform_enqueued_jobs do
        post password_resets_path, params: {password_reset: {email: user.email}}
        expect(response).to redirect_to root_path

        # Controllerのインスタンス変数を格納する
        user = assigns(:user)

        # 無効なメールアドレスの場合
        get edit_password_reset_path(user.reset_token, email: "")
        expect(response).to redirect_to root_path

        # 有効なメールアドレスで再設定トークンが無効の場合
        get edit_password_reset_path('wrong token', email: user.email)
        expect(response).to redirect_to root_path

        # メールアドレスとトークンが有効の場合
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(response).to render_template(:edit)

        # 無効なパスワードとパスワード確認
        patch password_reset_path(user.reset_token), params: {email: user.email, user: {password: "foobar",
                                                                                        password_confirmation: "foo"}}
        expect(response).to render_template(:edit)

        # 空のパスワードとパスワード確認
        patch password_reset_path(user.reset_token), params: {email: user.email, user: {password: "",
                                                                                        password_confirmation: ""}}
        expect(response).to render_template(:edit)

        # 有効なパスワードとパスワード確認
        patch password_reset_path(user.reset_token), params: {email: user.email, user: {password: "foobar",
                                                                                        password_confirmation: "foobar"}}
        expect(session[:user_id]).to eq user.id
        expect(response).to redirect_to user_path(user)
      end
    end
  end
end
