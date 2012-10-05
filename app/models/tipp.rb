class Tipp < ActiveRecord::Base
  attr_accessible :guest_goals, :home_goals, :user_id, :game_id
  
  belongs_to :user
  belongs_to :game
  has_one :matchday, through: :game
  has_one :season, through: :matchday
  
  validates_presence_of :user, :game
  
end
