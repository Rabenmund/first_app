class Tipp < ActiveRecord::Base
  attr_accessible :guest_goals, :home_goals, :user_id, :game_id
  
  belongs_to :user
  belongs_to :game
  has_one :matchday, through: :game
  has_one :season, through: :matchday
  
  validates_presence_of :user, :game, :guest_goals, :home_goals
  
  validate :user_active_in_season
  validate :game_can_be_tipped
  
  
  def self.active
    Tipp.joins(:game).where("finished = ? AND date > ?", false, DateTime.now)
  end
  
  def points
    if game.home_goals && game.guest_goals
      tipp_delta = home_goals - guest_goals
      game_delta = game.home_goals - game.guest_goals
      if (tipp_delta < 0 && game_delta < 0) || (tipp_delta == 0 && game_delta == 0) || (tipp_delta > 0 && game_delta > 0)
        calculate_points(tipp_delta, game_delta)
      else
        return 0
      end
    else
      return nil
    end
  end
  
  private
  
  def calculate_points(tipp_delta, game_delta)
    if tipp_delta == game_delta
      if home_goals == game.home_goals
        if (home_goals + guest_goals) > 3
          return (5 + (home_goals + guest_goals - 3))
        else
          return 5
        end
      else
        return 4
      end
    else
      return 3
    end
  end
  
  def user_active_in_season
    # only season_activated_users are allowed to add a tipp
    matchday.season.users.include?(user)
  end
  
  def game_can_be_tipped
    unless game.can_be_tipped?
      errors.add(:Spiel, "#{game.home.name}-#{game.guest.name} kann seit #{game.date} nicht mehr getippt werden.")
      return false
    end
  end

end
