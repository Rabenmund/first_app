class Tipp < ActiveRecord::Base
  attr_accessible :guest_goals, :home_goals, :user_id, :game_id
  
  belongs_to :user
  belongs_to :game
  has_one :matchday, through: :game
  has_one :season, through: :matchday
  
  validates_presence_of :user, :game
  
  validate :user_active_in_season
  
  
  def self.active
    Tipp.joins(:game).where("finished = ? AND date > ?", false, DateTime.now)
  end
  
  private
  
  def user_active_in_season
    # only season_activated_users are allowed to add a tipp
    matchday.season.users.include?(user)
  end

end
