class Season < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :team_ids, :user_ids, :finished
    
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate  :start_before_end_date
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :teams
  has_many :matchdays, dependent: :destroy, order: :number
  has_many :games, through: :matchdays
  has_many :tipps, through: :games
  has_many :results, class_name: "SeasonUserResult", order: "points DESC", dependent: :destroy
  
  # habtm is for simple use and does not support dependent: :destroy
  # for complex use has_many through: is needed
  # this hook clears the join tables for the habtm associations
  before_destroy { users.clear; teams.clear }
  
  # before_save :default_values
  # def default_values
  #   self.finished = false
  # end
  
  def next_matchday_number
    if matchdays.count > 0
      if matchdays.last.number < 34        
        matchdays.last.number + 1
      else
        return nil
      end
    else
      1
    end
  end
  
  def next_matchday_date
    if matchdays.count > 0
      go_friday_with(matchdays.last.date)
    else
      go_friday_with(start_date)
    end
  end
  
  def put_all_in_fri_row!(matchday)
    date = matchday.date
    matchdays.where('matchdays.number > ?', matchday.number).each do |m|
      new_date = go_friday_with date
      date = new_date
      m.update_attribute(:date, date)
    end
  end
  
  def self.active
    Season.where("finished = ? AND start_date < ? AND end_date > ?", false, DateTime.now, DateTime.now)
  end
  
  def active_matchdays
    matchdays.where("finished = ? AND date > ?", false, DateTime.now)
  end
  
  def matchdays_ordered_by_number
    matchdays.order(:number) if matchdays
  end
  
  def matchdays_finished
    res = []
    matchdays_ordered_by_number.each { |m| res << m if m.is_finished?}
    return res
  end
  
  def last_finished_matchday
    if matchdays &&  matchdays_finished.any? 
      return matchdays_finished.last 
    end
    return nil
  end
  
  def points_for(user)
    u_tipps = tipps.where(user_id: user.id).joins(:game).where(games: {finished: true})
    sum = 0  
    u_tipps.each {|t| sum += t.points  } if u_tipps.any?
    return sum
  end
  
  def users_ordered_by_points
    users.sort { |b,a| self.points_for(a) <=> self.points_for(b) }
  end
  
  def calculate_all
    matchdays.each { |md| md.games.first.save }
  end
  
  private 
  
  def go_friday_with(date)
    7.times do
      new_date = date + 1.day  
      date = new_date
      return date if date.wday == 5
    end
  end
  
  def start_before_end_date
    if (start_date && end_date)
      if start_date > end_date
        errors.add(:Saisonbeginn, "muss vor dem Saisonende liegen")
      end
    end
  end 
end
