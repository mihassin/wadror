class Session < ActiveRecord::Base
  validates :username, :password, presence: true
end
