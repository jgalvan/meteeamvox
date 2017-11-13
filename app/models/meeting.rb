class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true

  has_many :comments, dependent: :destroy
  has_many :meeting_invitations
  has_many :collaborators, through: :meeting_invitations, source: :user

  validates :meetingTime, presence: true
end
