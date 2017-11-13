class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user, presence: true, uniqueness: { scope: :friend }
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self
  validate :not_friends
  validate :not_requested

  def not_self
    if user == friend
      errors.add(:friend, :invalid, "can't be same as user")
    end
  end

  def not_friends
    if user.friends.include?(friend)
      errors.add(:friend, :invalid, 'has been added already') 
    end
  end

  def not_requested
    if friend.pending_friends.include?(user)
      errors.add(:user, :invalid, 'already has request pending') 
    end
  end
end
