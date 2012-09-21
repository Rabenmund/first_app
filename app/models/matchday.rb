#!/bin/env ruby
# encoding: utf-8

class Matchday < ActiveRecord::Base
  attr_accessible :date, :number, :season_id, :arrange_dates
  
  attr_accessor :arrange_dates
  
  belongs_to  :season
  has_many    :games
   
  validates :number, presence: true, numericality: true
  validates :date, presence: true
  validate  :date_in_date_range 
  validate  :date_in_order
  
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
  
  def teams(minusgame=nil)
    all = []
    games.each { |g| all |= g.teams unless g == minusgame }
    all
  end
  
  # falsch - nimmt
  # def teams
  #   Team.joins('INNER JOIN games ON (home_id = teams.id OR guest_id = teams.id)').uniq
  # end
  
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
