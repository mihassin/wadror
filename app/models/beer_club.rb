class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates_presence_of :name, :founded, :city
  validates :founded, numericality: { greater_than_or_equal_to: 1800, only_integer: true }

  def member?(user)
    users.include? user and memberships.find_by(user_id:user.id).confirmed
  end

  def to_s
    return "Club #{name} of #{city}"
  end
end
