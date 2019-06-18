# == Schema Information
#
# Table name: friendships
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active_friend_id  :integer
#  passive_friend_id :integer
#
# Indexes
#
#  index_friendships_on_active_friend_id                        (active_friend_id)
#  index_friendships_on_active_friend_id_and_passive_friend_id  (active_friend_id,passive_friend_id) UNIQUE
#  index_friendships_on_passive_friend_id                       (passive_friend_id)
#


require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:friendship) { FactoryBot.create(:friendship) }
  let(:legal_user) { User.first }
  let(:ilegal_user) { User.count.nil? ? 1 : User.count + 1 }
  
  #let(:fr_with_ilegal_requester) { FriendRequest.new(active_friend_id: ilegal_user, passive_friend_id: User.first.id) }
  #let(:fr_with_ilegal_requestee) { FriendRequest.new(active_friend_id: legal_user.id, passive_friend_id: ilegal_user) }

  describe 'test for presense of model attributes' do

    context 'general expected attributes' do
      it 'should include requester_id attribute' do
        expect(friendship.attributes).to include('active_friend_id')
      end

      it 'should include requestee_id attribute' do
        expect(friendship.attributes).to include('passive_friend_id')
      end
    end
  end

  describe 'Basic validations' do
    context 'requester_id' do
      it 'is valid with a active_friend_id' do 
        friendship.valid?
        expect(friendship.errors[:active_friend_id]).to_not include("can't be blank")
      end

      it 'is invalid without a active_friend_id' do 
        friendship.active_friend_id = nil
        friendship.valid?
        expect(friendship.errors[:active_friend_id]).to include("can't be blank")
      end
    end

    context 'requestee_id' do
      it 'is valid with a passive_friend_id' do 
        friendship.valid?
        expect(friendship.errors[:passive_friend_id]).to_not include("can't be blank")
      end

      it 'is invalid without a passive_friend_id' do 
        friendship.passive_friend_id = nil
        friendship.valid?
        expect(friendship.errors[:passive_friend_id]).to include("can't be blank")
      end
    end
   end

   describe 'Associations' do
    context 'user' do 
      it 'should belong to requestee' do 
        should belong_to(:passive_friend) 
      end 
      it 'should belong to requester' do 
        should belong_to(:active_friend) 
      end 
    end
  end

# TODO

=begin
  describe ' Constraints' do 
    context 'when friendship is created with requester_id that does not exist' do 
      it 'should raise user must exist error' do
        expect { fr_with_ilegal_requester.save! }.to  raise_error(
          ActiveRecord::RecordInvalid, 'Validation failed: ActiveFriend must exist'
        )
      end
    end 

    context 'when friendship is created with requester_id that does not exist' do 
      it 'should raise user must exist error' do
        expect { fr_with_ilegal_requestee.save! }.to  raise_error(
          ActiveRecord::RecordInvalid, 'Validation failed: PassiveFriend must exist'
        )
      end
    end 
  end
=end
end
