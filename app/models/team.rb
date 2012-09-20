class Team < ActiveRecord::Base
  attr_accessible :name, :season_ids
  
  has_and_belongs_to_many :seasons
  has_many :home_games, class_name: "Game", foreign_key: "home_id"
  has_many :guest_games, class_name: "Game", foreign_key: "guest_id"
  
  validates :name, presence: true, length: { maximum: 25, minimum: 5 }, uniqueness: { case_sensitive: false }
  
  def games
    home_games | guest_games
  end
  
  def games_per_season(season)
    games.select {|g| g.season == season}
  end
  
end
