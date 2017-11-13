class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :requests_made, class_name: "FriendRequest", dependent: :destroy
  has_many :pending_friends, through: :requests_made, source: :friend
  has_many :friend_requests, dependent: :destroy, foreign_key: "friend_id"
  has_many :pending_response_users, through: :friend_requests, source: :user
  
  has_many :friendships
  has_many :friends, through: :friendships
  
  has_many :meeting_invitations
  has_many :owned_meetings, class_name: "Meeting"
  has_many :accepted_meeting_invitations, -> { accepted }, class_name: "MeetingInvitation"
  has_many :joined_meetings, through: :accepted_meeting_invitations, source: :meeting

  has_many :team_memberships
  has_many :accepted_team_memberships, -> { accepted }, class_name: "TeamMembership"
  has_many :teams, through: :accepted_team_memberships
  #has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  #has_many :inverse_friends, through: :inverse_friendships, source: :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :country, presence: true
  

  def self.search(query) 
    if query 
      q = "%#{query}%"
      result = where("first_name LIKE :query", query: q)
      result = result.or(where("last_name LIKE :query", query: q))
      result = result.or(where("email LIKE :query", query: q))
      result = result.or(where("username LIKE :query", query: q))
    end
  end

  def meetings
    owned_meetings | joined_meetings
  end

  def meeting_with_id(id)
    owned_meetings.find_by_id(id) || joined_meetings.find_by_id(id)
  end

  def search_meeting(query)
    result = owned_meetings.where("title LIKE :query", query: "%#{query}%") | joined_meetings.where("title LIKE :query", query: "%#{query}%")
    result = result | owned_meetings.where("transcript LIKE :query", query: "%#{query}%") | joined_meetings.where("transcript LIKE :query", query: "%#{query}%")
  end

  def mutual_friends_with(other_user)
    friends & other_user.friends
  end
end
