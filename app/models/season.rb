class Season < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :team_ids, :user_ids
  
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :teams
  
end
