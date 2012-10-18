#!/bin/env ruby
# encoding: utf-8

class Matchday < ActiveRecord::Base
  attr_accessible :date, :number, :season_id, :arrange_dates, :finished
  
  attr_accessor :arrange_dates
  
  belongs_to                  :season
  has_many                    :games
  has_many                    :homes, through: :games
  has_many                    :guests, through: :games
  has_many                    :tipps, through: :games
  has_and_belongs_to_many     :winners, class_name: "User", join_table: :matchdays_winners
  has_and_belongs_to_many     :seconds, class_name: "User", join_table: :matchdays_seconds
   
  validates :number, presence: true, numericality: true
  validates :date, presence: true
  validate  :date_in_date_range 
  validate  :date_in_order
  
  # before_save :default_values
  # def default_values
  #   self.finished = false
  # end
  
  def is_wday?(d)
    date.wday == d
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
  
  def arrange_dates?
    arrange_dates == "1"
  end
  
  def teams
    res = []
    self.games.each do |g| 
      res << g.home
      res << g.guest
    end
    return res
  end
  
  def free_teams
    season.teams - teams
  end
  
  def self.active
    Matchday.where("finished = ? AND date > ?", false, DateTime.now)
  end
  
  def has_games_to_tipp?
    games.each do |game|
      return true if game.can_be_tipped?
    end
    return false
  end
  
  private
  
  def date_in_date_range
    if date
      if (date < season.start_date) || (date > season.end_date)
        errors.add(:Datum, "muss im Datumsbereich der Saison liegen: #{season.start_date.to_date} - #{season.end_date.to_date}")
        return false
      end
    end
  end

  def date_in_order
    return if arrange_dates?
    if date
      matchdays_before = season.matchdays.where("matchdays.number < ?", number)
      matchdays_before.each do |m|
        if m.date > date
          errors.add(:Datum, "vor dem früheren Spieltag #{m.number}: #{m.date.to_date}")
          return false
        end
      end
      matchdays_after = season.matchdays.where("matchdays.number > ?", number)
      matchdays_after.each do |m|
        if m.date < date
          errors.add(:Datum, "nach dem späteren Spieltag #{m.number}: #{m.date.to_date}")
          return false
        end
      end
    end
  end
    
end
