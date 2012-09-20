#!/bin/env ruby
# encoding: utf-8

class Game < ActiveRecord::Base
  attr_accessible :guest_goals, :home_goals, :home_id, :guest_id, :matchday_id, :date
  
  belongs_to :matchday
  belongs_to :home, class_name: "Team"
  belongs_to :guest, class_name: "Team"
  has_one    :season, through: :matchday
  
  validates :guest_id,    presence: true
  validates :home_id,     presence: true
  validates :matchday_id, presence: true
  validates :date,        presence: true
  
#  validate  :home_associated_to_season
#  validate  :guest_associated_to_season
#  validate  :date_in_seasons_range
#  validate  :home_not_used_in_matchday
#  validate  :guest_not_used_in_matchday
#  validate  :game_not_used_in_season
  
  
  def teams
    [home] | [guest]
  end
  
  private
  
  def game_not_used_in_season
#    season.games.where(home_id: home.id, guest_id: guest.id).empty?
  end
  
  def home_not_used_in_matchday
    !team_used_in_matchday?(home, :Heim)
  end
  
  def guest_not_used_in_matchday
    !team_used_in_matchday?(guest, :Gast)
  end
  
  def home_associated_to_season
    team_associated_to_season?(home, :Heim)
  end
  
  def guest_associated_to_season
    team_associated_to_season?(guest, :Gast)
  end
  
  def team_used_in_matchday?(team, sym)
    return false unless matchday && home && guest
    if (matchday.teams.include?(team))
      errors.add(sym, "#{team.name} wird bereits in einem anderen Spiel des Spieltages verwendet")
      return false
    end
    return true
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
  
end
