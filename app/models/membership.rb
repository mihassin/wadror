class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates_uniqueness_of :user_id, :beer_club_id
end
