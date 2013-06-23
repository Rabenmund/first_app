class Team < ActiveRecord::Base
  attr_accessible :name, :season_ids, :shortname, :chars
  
  has_and_belongs_to_many :seasons
  has_many :home_games, class_name: "Game", foreign_key: "home_id", dependent: :destroy
  has_many :guest_games, class_name: "Game", foreign_key: "guest_id", dependent: :destroy
  
  # habtm is for simple use and does not support dependent: :destroy
  # for complex use has_many through: is needed
  # this hook clears the join tables for the habtm associations
  before_destroy { seasons.clear }
  
  validates :name, presence: true, length: { maximum: 25, minimum: 5 }, uniqueness: { case_sensitive: false }
  
  def games
    home_games | guest_games
  end
  
  def games_per_season(season)
    games.select {|g| g.season == season}
  end
  
end
