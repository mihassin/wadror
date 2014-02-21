class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates :user, uniqueness: {scope: :beer_club}

  scope :confirmed, -> { where confirmed:true }
  scope :unconfirmed, -> { where confirmed:[nil,false] }
end
