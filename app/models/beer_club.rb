class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates_presence_of :city
  validates :founded, numericality: { less_than_or_equal_to: ->(_) { Time.now.year} }
  validates :name, uniqueness: true, length: { minimum: 3, maximum: 30 }

  def member?(user)
    users.include? user and memberships.find_by(user_id:user.id).confirmed
  end

  def to_s
    return "Club #{name} of #{city}"
  end
end
