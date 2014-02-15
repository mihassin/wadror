class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates :user, uniqueness: {scope: :beer_club}
end
