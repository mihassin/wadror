class BeerClub < ActiveRecord::Base
  def future_year
    if founded > Date.today.year
      errors.add(:founded, "seems to be incorrect")
    end
  end

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates_presence_of :name, :founded, :city
  validates :founded, numericality: { greater_than_or_equal_to: 1800, only_integer: true }
  validate :future_year
  validates :name, uniqueness: true, length: { minimum: 3, maximum: 30 }

  def member?(user)
    users.include? user and memberships.find_by(user_id:user.id).confirmed
  end

  def to_s
    return "Club #{name} of #{city}"
  end
end
