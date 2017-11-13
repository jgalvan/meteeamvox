class MeetingInvitation < ApplicationRecord
  belongs_to :meeting
  belongs_to :user
  
  enum status: [:pending, :accepted, :rejected]

  validates :user, uniqueness: { scope: :meeting }
end
