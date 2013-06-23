class MatchdayUserResult < ActiveRecord::Base
  # association model/table for matchday and users with calculated points
  
  attr_accessible :matchday_id, :points, :user_id
  
  belongs_to :matchday
  belongs_to :user
  has_many :games, through: :matchday
  has_many :tipps, through: :games, conditions: proc { ["tipps.user_id = ?", user.id] }
  
  validates_presence_of :user, :matchday
  
  after_save :calculate
  
  def calculate
    # calculates and sets points to this model
    self.points = 0
    tipps.each { |t| self.points += t.points }
  end
end
