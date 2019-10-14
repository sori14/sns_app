require 'rails_helper'

RSpec.describe "RelationshipsController", type: :request do
  let(:user) {FactoryBot.create(:user)}
  let(:other_user) {FactoryBot.create(:user)}

  before {sign_in_as user}

  describe "creating a relationship with Ajax" do
    it "should increment the Relationship count" do
      expect {
        post relationships_path, xhr: true, params: {followed_id: other_user.id}
      }.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      post relationships_path, xhr: true, params: {followed_id: other_user.id}
      expect(response).to be_successful
    end
  end

  describe "destroying a relationship with Ajax" do
    before {user.follow(other_user)}

    let(:relationship) {
      user.active_relationships.find_by(followed_id: other_user.id)
    }

    it "should decrement the Relationship count" do
      expect{
        delete relationship_path(relationship.id), xhr: true
      }.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      delete relationship_path(relationship.id), xhr: true
      expect(response).to be_successful
    end
  end
end
