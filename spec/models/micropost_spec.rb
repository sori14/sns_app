require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) {FactoryBot.create(:user)}

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  it "should be user column" do
    expect(@micropost).to respond_to(:content)
    expect(@micropost).to respond_to(:user_id)
    expect(@micropost).to respond_to(:user)
    expect(@micropost.user).to eq user
    expect(@micropost).to be_valid
  end

  describe "when user_id is not present" do
    before {@micropost.user_id = nil}
    it 'should be valid' do
      expect(@micropost).to be_invalid
    end
  end

  describe "when user_id is not present" do
    before {@micropost.user_id = nil}
    it 'should be invalid' do
      expect(@micropost).to be_invalid
    end
  end

  describe 'with blank content' do
    before {@micropost.content = ""}
    it 'should be invalid' do
      expect(@micropost).to be_invalid
    end
  end

  describe 'with content that is too long' do
    before {@micropost.content = "a" * 141}
    it 'should be invalid' do
      expect(@micropost).to be_invalid
    end
  end

  describe "search association" do
    before do
      3.times {FactoryBot.create(:micropost,user: user)}
    end

    it "should have micropost content of 'Lorem ipsum 2' by search" do
      microposts = user.microposts.search("Lorem ipsum 2")
      expect(microposts.count).to eq 1
      expect(microposts.first.content).to eq "Lorem ipsum 2"
    end
  end
end
