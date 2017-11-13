class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user, uniqueness: { scope: :team }

  enum status: [:pending, :accepted, :rejected]
end
