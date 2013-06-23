class SeasonUserResult < ActiveRecord::Base
  # association model/table for season and users with calculated points
  
  attr_accessible :season_id, :points, :user_id
  
  belongs_to :season
  belongs_to :user
  has_many :games, through: :season
  has_many :tipps, through: :games, conditions: proc { ["tipps.user_id = ?", user.id] }
  
  validates_presence_of :user, :season
  
  after_save :calculate
  
  def calculate
    # calculates and sets points to this model
    self.points = 0
    tipps.each { |t| self.points += t.points }
  end
  
end
