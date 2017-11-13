class Friendship < ApplicationRecord
  after_create :create_inverse_friendship
  after_destroy :destroy_inverse_friendship

  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user, presence: true, uniqueness: { scope: :friend }
  validates :friend, presence: true, uniqueness: { scope: :user }
  
  private
  
  def create_inverse_friendship
    friend.friendships.create(friend: user)
  end
  
  def destroy_inverse_friendship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end
end
