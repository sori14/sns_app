require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:follower) {FactoryBot.create(:user)}
  let(:followed) {FactoryBot.create(:user)}
  let(:relationship) {follower.active_relationships.build(followed_id: followed.id)}

  it 'should be valid' do
    expect(relationship).to be_valid
  end

  describe 'should be follower methods' do
    it 'should work normally' do
      expect(relationship).to respond_to(:follower)
      expect(relationship).to respond_to(:followed)
      expect(relationship.follower).to eq follower
      expect(relationship.followed).to eq followed
    end
  end

  describe 'when followed id is not present' do
    before {relationship.followed_id = nil}
    it 'should be invalid' do
      expect(relationship).to be_invalid
    end
  end

  describe 'when follower id is not present' do
    before {relationship.followed_id = nil }
    it 'should be invalid' do
      expect(relationship).to be_invalid
    end
  end
end
