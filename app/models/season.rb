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
  
  def self.my_active(user)
    self.active.joins(:users).where("user_id = ?", user.id)
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
