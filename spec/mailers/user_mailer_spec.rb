require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) {FactoryBot.create(:user)}

  describe "account_activation" do
    let(:mail) {UserMailer.account_activation(user)}

    # メールの送信テスト
    it "renders the headers" do
      expect(mail.to).to eq ["user1@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "Account activation"
    end

    # メールのプレビューのテスト
    it "renders the body" do
      # matchマッチャは文字列、ハッシュ、配列の中身に使用できる
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      # Rails側でURLの組み込めるようにエスケープされている為、CGI.escapeメソッドを使用する
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "password_reset" do
    let(:mail) {UserMailer.password_reset(user)}

    it "renders the headers" do
      # トークンがテストでは作成されないため、作成する
      user.reset_token = User.new_token
      expect(mail.to).to eq ["user3@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "Password reset"
    end

    it "renders the body" do
      user.reset_token = User.new_token
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

end
