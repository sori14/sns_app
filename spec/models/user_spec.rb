require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = FactoryBot.build(:user)
  end

  describe 'respond_to' do
    it 'should have colums' do
      expect(@user).to respond_to(:admin)
      expect(@user).to respond_to(:microposts)
    end

    it 'feed method should work normally' do
      expect(@user).to respond_to(:feed)
    end

    it 'relationship method should work normally' do
      expect(@user).to respond_to(:active_relationships)
      expect(@user).to respond_to(:passive_relationships)
    end

    it 'following and followed method should work normally' do
      expect(@user).to respond_to(:following)
      expect(@user).to respond_to(:followers)
    end

    it 'follow and unfollow method should work normally' do
      expect(@user).to respond_to(:follow)
      expect(@user).to respond_to(:unfollow)
      expect(@user).to respond_to(:following?)
    end
  end

  describe "presence" do
    it "値が入ってる場合" do
      expect(@user).to be_valid
    end

    it "emailが空白の場合" do
      @user.email = " "
      expect(@user).to be_invalid
    end

    it "passwordが6文字以上の場合" do
      # aが6文字のパスワードのテスト
      @user.password = @user.password_confirmation = "a" * 6
      expect(@user).to be_valid
    end

    it "passwordが空白の場合" do
      # 空白が6文字のパスワードのテスト
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).to be_invalid
    end
  end

  describe "email format" do
    context "when email format is valid" do
      it "正しいemailのフォーマット" do
        address = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        address.each do |valid_address|
          expect(FactoryBot.build(:user, email: valid_address)).to be_valid
        end
      end
    end

    context "when email format is invalid" do
      it "間違ったemailのフォーマット" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          expect(FactoryBot.build(:user, email: invalid_address)).to be_invalid
        end
      end
    end

    it "emailを小文字に返還後の値と大文字を混ぜて登録されたアドレスが同じか" do
      @user.email = "Foo@ExAMPle.COm"
      @user.save!
      expect(@user.reload.email).to eq "foo@example.com"
    end
  end

  describe "unique" do
    context "when email addresses should be unique" do
      it "一意性が正しく機能しているか" do
        # @userを複製して、格納する => dupメソッドで同属性のモデルを生成する
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        # 最初にモデルをDBに格納する
        @user.save!
        expect(duplicate_user).to be_invalid
      end
    end
  end


  describe "password length" do
    context "パスワードが6桁の時" do
      it "正しい" do
        @user = FactoryBot.build(:user, password: "a" * 6, password_confirmation: "a" * 6)
        expect(@user).to be_valid
      end
    end

    context "パスワードが5桁の時" do
      it "正しくない" do
        @user = FactoryBot.build(:user, password: "a" * 5, password_confirmation: "a" * 5)
        expect(@user).to be_invalid
      end
    end
  end

  describe "カラムがあるかどうか" do
    it "should respond to 'name'" do
      expect(@user).to respond_to(:name)
    end

    it "should respond to 'email'" do
      expect(@user).to respond_to(:email)
    end

    it "should respond to 'password_digest'" do
      expect(@user).to respond_to(:password_digest)
    end

    it "should respond to 'password'" do
      expect(@user).to respond_to(:password)
    end

    it "should respond to 'password_confirmation'" do
      expect(@user).to respond_to(:password_confirmation)
    end

    it "should respond to 'authenticate'" do
      expect(@user).to respond_to(:authenticate)
    end
  end

  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}
    it "with valid password" do
      expect(@user).to eq found_user.authenticate(@user.password)
    end
    let(:user_for_invalid_password) {found_user.authenticate("invalid")}
    it "with invalid password" do
      expect(@user).to_not eq :user_for_invalid_password
      expect(user_for_invalid_password).to be_falsey
    end
  end

  # 異なるブラウザでログアウトした場合に、cokkiesメソッドでエラーが起きるテスト
  describe "authenticated? should return false for a user with nil digest" do
    it "is invalid without remember_digest" do
      expect(@user.authenticated?(:remember, '')).to eq false
    end
  end

  describe "micropost associations" do
    before {@user.save}
    let!(:old_micropost) {
      FactoryBot.create(:micropost, user: @user, created_at: 1.day.ago)
    }
    let!(:newer_micropost) {
      FactoryBot.create(:micropost, user: @user, created_at: 1.hour.ago)
    }
    let(:unfollowed_micropost) {
      FactoryBot.create(:micropost, user: FactoryBot.create(:user))
    }

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, old_micropost]
    end

    it 'should destroy associated microposts' do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    it 'should have my microposts' do
      expect(@user.feed).to include(old_micropost)
      expect(@user.feed).to include(newer_micropost)
      expect(@user.feed).to_not include(unfollowed_micropost)
    end
  end

  describe 'following' do
    let(:other_user) {FactoryBot.create(:user)}
    before do
      @user.save
      @user.follow(other_user)
    end

    it 'should have followed other_user' do
      expect(@user.following?(other_user)).to be_truthy
      expect(@user.following).to include(other_user)
    end

    describe 'and unfollowing' do
      before {@user.unfollow(other_user)}

      it "should not have followed other_user" do
        expect(@user.followers).to_not include(other_user)
      end
    end

    # 逆リレーションシップのテスト
    describe 'followed user' do
      it 'followed user' do
        expect(other_user.followers).to include(@user)
      end
    end
  end

  describe "micropost associations" do
    before {@user.save}
    let(:older_micropost) {
      FactoryBot.create(:micropost, user: @user, created_at: 1.day.ago)
    }
    let(:newer_micropost) {
      FactoryBot.create(:micropost, user: @user, created_at: 1.hour.ago)
    }

    describe "status" do
      let(:unfollowed_micropost) {
        FactoryBot.create(:micropost, user: FactoryBot.create(:user))
      }
      let(:followed_user) {FactoryBot.create(:user)}

      before {
        @user.follow(followed_user)
        3.times {followed_user.microposts.create(content: "Lorem ipsum")}
      }

      it "should include newer_micropost" do
        expect(@user.feed).to include(newer_micropost)
      end

      it "should include older_micropost" do
        expect(@user.feed).to include(older_micropost)
      end

      it "should not include unfollowed_micropost" do
        expect(@user.feed).to_not include(unfollowed_micropost)
      end

      it "should include followed_micropost" do
        followed_user.microposts.each do |micropost|
          expect(@user.feed).to include(micropost)
        end
      end
    end
  end

  describe "search associations" do
    let(:user) {FactoryBot.create(:user)}
    before do
      # ３人のユーザをDBに登録する
      3.times {FactoryBot.create(:user)}
    end

    it "should have user name of 'Example user55' by search" do
      # 検索の実行
      users = User.all.search(user.name)
      expect(users.count).to eq 1
      expect(users.first.name).to eq user.name
    end
  end
end
