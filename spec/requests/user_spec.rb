require 'rails_helper'

RSpec.describe "User pages", type: :request do
  let(:user) {FactoryBot.create(:user)}
  let(:other_user) {FactoryBot.create(:user)}

  describe "GET #new" do
    it "return http success" do
      get signup_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    # ログイン済みのユーザ
    context "as an authenticated user" do
      it "should successfully respond" do
        sign_in_as user
        get user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
    end

    # ログインしていないユーザ
    context "as a guest" do
      it 'should redirect to the login page' do
        get user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET #index" do
    # 認可されたユーザの場合
    context "as an authenticated user" do
      it "should successfully respond" do
        sign_in_as user
        get users_path
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
    end

    # ログインしていないユーザの場合
    context "as a guest" do
      it "should redirect to the login page" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET #edit" do
    # 認可されたユーザとして
    context "as an authorized" do
      it "responds successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
    end

    # ログインしていないユーザの場合
    context "as a guest" do
      # ログイン画面にリダイレクトする
      it "redirect to the login page" do
        get edit_user_path(user)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to login_path
      end
    end

    #アカウントが違うユーザの場合
    context "as other user" do
      it "redirects to the login page" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH #update" do
    # 認可されたユーザーの場合
    context "as authorized user" do
      # ユーザを更新できること
      it "updates a user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as user
        patch user_path(user), params: {id: user.id, user: user_params}
        expect(user.reload.name).to eq "NewName"
      end
    end

    # ログインされていないユーザの場合
    context "as a guest" do
      it "does not update the user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        patch user_path(user), params: {id: user.id, user: user_params}
        expect(response).to have_http_status(302)
        expect(response).to redirect_to login_path
      end
    end

    # アカウントが違うユーザの場合
    context "as other guest" do
      # ユーザが更新できないこと
      it "does not update the user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: {id: user.id, user: user_params}
        expect(user.reload.name).to eq user.name
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroy" do
    # 認可されたユーザの場合
    context "as an authorized user" do
      it "deletes a user" do
        sign_in_as user
        expect {
          delete user_path(user), params: {id: user.id}
        }.to change(User, :count).by(-1)
      end
    end

    # アカウントの違うユーザーの場合
    context "as an unauthorized user" do
      it "redirects to the dashboard" do
        sign_in_as other_user
        delete user_path(user), params: {id: user.id}
        expect(response).to redirect_to users_path
      end
    end

    # ゲストユーザの場合
    context "as a guest" do
      it "return a 302 response" do
        delete user_path(user), params: {id: user.id}
        expect(response).to have_http_status(302)
      end

      it "redirect to the sign_in page" do
        delete user_path(user), params: {id: user.id}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "POST #create" do
    include ActiveJob::TestHelper

    it "is invalid with invalid signup information" do
      perform_enqueued_jobs do
        expect {
          # 新規登録ユーザ
          post users_path, params: {user: {name: "",
                                           email: "user@invalid",
                                           password: "foo",
                                           password_confirmation: "bar"}}
        }.to_not change(User, :count)
      end
    end

    it "is valid with valid signup information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: {user: {name: "ExampleUser",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password"}}
        }.to change(User, :count).by(1)
        expect(response).to redirect_to root_path
        # コントローラー内のインスタンス変数を格納
        # この場合、params[:user]
        user = assigns(:user)
        # 有効化していないユーザのログインはセッションが登録されない
        sign_in_as user
        expect(session[:user_id]).to be_falsey

        # アカウントの有効化トークンが不正の場合は、セッションが登録されない
        get edit_account_activation_path('invalid token', email: user.email)
        expect(session[:user_id]).to be_falsey

        # トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user.activation_token, email: 'wrong email')
        expect(session[:user_id]).to be_falsey

        # 有効化トークンが正しい場合
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(session[:user_id]).to eq user.id
        expect(user.name).to eq "ExampleUser"
        expect(user.email).to eq "user@example.com"
        expect(user.password).to eq "password"
      end
    end
  end
end
