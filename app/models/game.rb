#!/bin/env ruby
# encoding: utf-8

class Game < ActiveRecord::Base
  attr_accessible :guest_goals, :home_goals, :home_id, :guest_id, :matchday_id, :date, :finished
  
  belongs_to :matchday
  belongs_to :home, class_name: "Team"
  belongs_to :guest, class_name: "Team"
  has_one    :season, through: :matchday
  has_many   :tipps
  
  validates :guest_id,    presence: true
  validates :home_id,     presence: true
  validates :matchday_id, presence: true
  validates :date,        presence: true
  
  validate  :home_associated_to_season
  validate  :guest_associated_to_season
  validate  :date_in_seasons_range
  validate  :game_count
  validate  :home_unique_at_matchday
  validate  :guest_unique_at_matchday
  validate  :home_not_guest
  
  # before_save :default_values
  # def default_values
  #   self.finished = false
  # end
  
  def teams
    return [home, guest]
  end
  
  def has_wday_humanize
    case date.wday
    when 1
      "Montag"
    when 2 
      "Dienstag"
    when 3 
      "Mittwoch"
    when 4 
      "Donnerstag"
    when 5 
      "Freitag"
    when 6 
      "Samstag"
    when 0 
      "Sonntag"
    end
  end
  
  def self.active
    Game.where("finished = ? AND date > ?", false, DateTime.now)
  end
  
  private
  
  def home_not_guest
    if home_id == guest_id
      errors.add(:Heim, "darf nicht gleich Gast sein.")
      return false
    end
  end
  
  def home_unique_at_matchday
    return false unless matchday
    matchday.games.each do |g| 
      if (g.home == home or g.guest == home) && g != self
        errors.add(:Heim, "wird bereits an dem Spieltag verwendet")
        return false
      end
    end
  end
  
  def guest_unique_at_matchday
    return false unless matchday
    matchday.games.each do |g| 
      if (g.home == guest or g.guest == guest) && g != self
        errors.add(:Gast, "wird bereits an dem Spieltag verwendet")
        return false
      end
    end
  end
  
  def game_not_used_in_season
#    season.games.where(home_id: home.id, guest_id: guest.id).empty?
    
  end
  
  def home_associated_to_season
    team_associated_to_season?(home, :Heim)
  end
  
  def guest_associated_to_season
    team_associated_to_season?(guest, :Gast)
  end
  
  def date_in_seasons_range
    return false unless (!date.nil? && !matchday.nil?)
    unless (date >= season.start_date && date <= season.end_date) 
      errors.add(:Date, "#{date} liegt nicht im Datumsbereich der Saison: #{season.start_date} - #{season.end_date}")
    end
  end
  
  def team_associated_to_season?(team, sym)
    return false unless (!matchday.nil? && !home.nil? && !guest.nil?)
    unless season.teams.include?(team)
      errors.add(sym, "#{team.name} gehört nicht zur Saison #{season.name}.")
      return false
    end
    return true
  end
  
  def game_count
    return false unless (!matchday.nil? && !home.nil? && !guest.nil?)
    if self.matchday.games.count > 9
      errors.add(:Spiel, "kann nicht erstellt werden. Spieltag #{matchday.id} hat bereits 9 Spiele")
      return false
    end
  end
  
end
