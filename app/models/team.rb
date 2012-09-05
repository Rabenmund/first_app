class Team < ActiveRecord::Base
  attr_accessible :name, :season_ids
  
  
  has_and_belongs_to_many :seasons
  
  validates :name, presence: true, length: { maximum: 25, minimum: 5 }, uniqueness: { case_sensitive: false }
  
end
