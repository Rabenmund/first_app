#!/bin/env ruby
# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_girl_rails'

puts "INTERMEDIATE: DELETE ALL"
Season.destroy_all
Team.destroy_all
Game.destroy_all
Matchday.destroy_all
Tipp.destroy_all



puts "Starts Seeds..."

###################
#     Admin       #
###################
adminname = "Admin"

unless User.find_by_name(adminname)
  puts "User: <#{adminname}> not found - will be created."
  admin = User.new(name: adminname, nickname: adminname, email: "#{adminname}@example.com", password: "password", password_confirmation: "password")
  admin.admin = true
  admin.deactivated = true
  if admin.save
    puts "User: <#{adminname}> created successfully!"
  else
    puts "User: <#{adminname}> not created!"
  end
else
  puts "User: <#{adminname}> found!"
end

admin = User.find_by_name(adminname)


###################
#     Season      #
###################

mastername =  "Master 2012/2013"
start_date =  "01.08.2012"
end_date =    "31.07.2013"

unless Season.find_by_name(mastername)
  puts "Season: master season <#{mastername}> not found - will create."
  FactoryGirl.create :season, name: mastername, start_date: start_date, end_date: end_date
  puts "Season: master season <#{mastername}> created!"
else
  puts "Season: master season <#{mastername}> found!"
end

masterseason = Season.find_by_name(mastername)

###################
#     Users       #
###################

unless User.count > 99
  puts "User: Not enough user found. Will create #{100-User.count} users."
  (100-User.count).times { FactoryGirl.create :user, deactivated: false }
  puts "User: all needed users created!"
else
  puts "User: Enough user found!"
end

puts "Users->Season: ensure all Users are associated to <#{masterseason.name}>"
User.all.each { |u| masterseason.users << u unless u.seasons.include?  masterseason || u.name == adminname}

###################
#     Teams       #
###################

teams = {
  fcb: {
    name: "Bayern München",
    short: "München"
  },
  hsv: {
    name: "Hamburger SV",
    short: "Hamburg"
  },
  s04: {
    name: "Schalke 04 Gelsenkirchen",
    short: "Schalke 04"
  },
  bvb: {
    name: "Borussia Dortmund",
    short: "Dortmund"
  },
  b04: {
    name: "Bayer 04 Leverkusen",
    short: "Leverkusen"
  },
  svw: {
    name: "SV Werder Bremen",
    short: "Bremen"
  },
  h96: {
    name: "SV Hannover 96",
    short: "Hannover"
  },
  fcn: {
    name: "1.FC Nürnberg",
    short: "Nürnberg"
  },
  gla: {
    name: "Borussia Mönchengladbach",
    short: "Gladbach"
  },
  scf: {
    name: "Freiburger SC",
    short: "Freiburg"
  },
  m05: {
    name: "1.FSV Mainz 05",
    short: "Mainz"
  },
  tsg: {
    name: "TSG 1899 Hoffenheim",
    short: "Hoffenheim"
  },
  vfb: {
    name: "VfB Stuttgart",
    short: "Stuttgart"
  },
  f95: {
    name: "Fortuna Düsseldorf",
    short: "Düsseldorf"
  },
  sge: {
    name: "Eintracht Frankfurt",
    short: "Frankfurt"
  },
  fca: {
    name: "FC Augsburg",
    short: "Augsburg"
  },
  wol: {
    name: "VfL Wolfsburg",
    short: "Wolfsburg"
  },
  grf: {
    name: "SpVgg Greuther Fürth",
    short: "Fürth"
  }
  
}

puts "Teams: ensure existance of all needed teams. "
teams.each do |key, value|
  t = Team.find_or_create_by_name(value[:name], { name: value[:name], shortname: value[:short], chars: key.to_s})
  masterseason.teams << t unless masterseason.teams.include? t
end

###################
#   Matchdays     #
###################

matchday_dates = [
  "24.08.2012", "31.08.2012", "14.09.2012", "21.09.2012", "25.09.2012", "28.09.2012", "05.10.2012",
  "19.10.2012", "26.10.2012", "02.11.2012", "09.11.2012", "17.11.2012", "23.11.2012", "27.11.2012",
  "30.11.2012", "07.12.2012", "14.12.2012", "18.01.2013", "25.01.2013", "01.02.2013", "09.02.2013", 
  "15.02.2013", "22.02.2013", "01.03.2013", "08.03.2013", "15.03.2013", "30.03.2013", "05.04.2013", 
  "12.04.2013", "19.04.2013", "26.04.2013", "03.05.2013", "11.05.2013", "18.05.2013"
]
    
i = 0
matchday_dates.each do |d|
  i += 1
  FactoryGirl.create :matchday, number: i, date: d, season: masterseason
end

###################
#     Games       #
###################

puts "Game: bring in all games"

mds = {
  m1: { 
    s1: [ :bvb, :svw, 2, 1, true ],
    s2: [ :gla, :tsg, 2, 1, true ],
    s3: [ :vfb, :wol, 0, 1, true ],
    s4: [ :h96, :s04, 2, 2, true ],
    s5: [ :scf, :m05, 1, 1, true ],
    s6: [ :fca, :f95, 0, 2, true ],
    s7: [ :hsv, :fcn, 0, 1, true ],
    s8: [ :grf, :fcb, 0, 3, true ],
    s9: [ :sge, :b04, 2, 1, true ]
  },
  m2: { 
    s1: [ :m05, :grf, 0, 1, true ],
    s2: [ :s04, :fca, 3, 1, true ],
    s3: [ :b04, :scf, 2, 0, true ],
    s4: [ :svw, :hsv, 2, 0, true ],
    s5: [ :fcn, :bvb, 1, 1, true ],
    s6: [ :tsg, :sge, 0, 4, true ],
    s7: [ :f95, :gla, 0, 0, true ],
    s8: [ :wol, :h96, 0, 4, true ],
    s9: [ :fcb, :vfb, 6, 1, true ]
  },
  m3: { 
    s1: [ :fca, :wol, 0, 0, true ],
    s2: [ :bvb, :b04, 3, 0, true ],
    s3: [ :fcb, :m05, 3, 1, true ],
    s4: [ :gla, :fcn, 2, 3, true ],
    s5: [ :vfb, :f95, 0, 0, true ],
    s6: [ :h96, :svw, 3, 2, true ],
    s7: [ :grf, :s04, 0, 2, true ],
    s8: [ :scf, :tsg, 5, 3, true ],
    s9: [ :sge, :hsv, 3, 2, true ]
  },
  m4: { 
    s1: [ :fcn, :sge, 1, 2, true ],
    s2: [ :s04, :fcb, 0, 2, true ],
    s3: [ :wol, :grf, 1, 1, true ],
    s4: [ :m05, :fca, 2, 0, true ],
    s5: [ :hsv, :bvb, 3, 2, true ],
    s6: [ :f95, :scf, 0, 0, true ],
    s7: [ :b04, :gla, 1, 1, true ],
    s8: [ :svw, :vfb, 2, 2, true ],
    s9: [ :tsg, :h96, 3, 1, true ]
  },
  m5: { 
    s1: [ :fcb, :wol, 3, 0, true ],
    s2: [ :s04, :m05, 3, 0, true ],
    s3: [ :grf, :f95, 0, 2, true ],
    s4: [ :sge, :bvb, 3, 3, true ],
    s5: [ :gla, :hsv, 2, 2, true ],
    s6: [ :vfb, :tsg, 0, 3, true ],
    s7: [ :h96, :fcn, 4, 1, true ],
    s8: [ :scf, :svw, 1, 2, true ],
    s9: [ :fca, :b04, 1, 3, true ]
  },
  m6: { 
    s1: [ :f95, :s04, 2, 2, true ],
    s2: [ :b04, :grf, 2, 0, true ],
    s3: [ :svw, :fcb, 0, 2, true ],
    s4: [ :fcn, :vfb, 0, 2, true ],
    s5: [ :tsg, :fca, 0, 0, true ],
    s6: [ :hsv, :h96, 1, 0, true ],
    s7: [ :bvb, :gla, 5, 0, true ],
    s8: [ :sge, :scf, 2, 1, true ],
    s9: [ :wol, :m05, 0, 2, true ]
  },
  m7: { 
    s1: [ :fca, :svw, 3, 1, true ],
    s2: [ :fcb, :tsg, 2, 0, true ],
    s3: [ :s04, :wol, 3, 0, true ],
    s4: [ :scf, :fcn, 3, 0, true ],
    s5: [ :m05, :f95, 1, 0, true ],
    s6: [ :grf, :hsv, 0, 1, true ],
    s7: [ :gla, :sge, 2, 0, true ],
    s8: [ :vfb, :b04, 2, 2, true ],
    s9: [ :h96, :bvb, 1, 1, true ]
  },
  m8: { 
    s1: [ :tsg, :grf, 0, 0, true ],
    s2: [ :bvb, :s04, 0, 0, true ],
    s3: [ :b04, :m05, 0, 0, true ],
    s4: [ :wol, :scf, 0, 0, true ],
    s5: [ :sge, :h96, 0, 0, true ],
    s6: [ :f95, :fcb, 0, 0, true ],
    s7: [ :svw, :gla, 0, 0, true ],
    s8: [ :fcn, :fca, 0, 0, true ],
    s9: [ :hsv, :vfb, 0, 0, true ]
  },
  m9: { 
    s1: [ :fca, :hsv, 0, 2, true ],
    s2: [ :s04, :fcn, 1, 0, true ],
    s3: [ :scf, :bvb, 0, 2, true ],
    s4: [ :m05, :tsg, 3, 0, true ],
    s5: [ :grf, :svw, 1, 1, true ],
    s6: [ :f95, :wol, 1, 4, true ],
    s7: [ :vfb, :sge, 2, 1, true ],
    s8: [ :fcb, :b04, 1, 2, true ],
    s9: [ :h96, :gla, 2, 3, true ]
  }
  m10: { 
    s1: [ :xxx, :xxx, , , false ],
    s2: [ :xxx, :xxx, , , false ],
    s3: [ :xxx, :xxx, , , false ],
    s4: [ :xxx, :xxx, , , false ],
    s5: [ :xxx, :xxx, , , false ],
    s6: [ :xxx, :xxx, , , false ],
    s7: [ :xxx, :xxx, , , false ],
    s8: [ :xxx, :xxx, , , false ],
    s9: [ :xxx, :xxx, , , false ]
  },
  m11: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m12: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m13: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m14: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m15: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m16: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  },
  m17: { 
    s1: [ :xxx, :xxx, 0, 0, true ],
    s2: [ :xxx, :xxx, 0, 0, true ],
    s3: [ :xxx, :xxx, 0, 0, true ],
    s4: [ :xxx, :xxx, 0, 0, true ],
    s5: [ :xxx, :xxx, 0, 0, true ],
    s6: [ :xxx, :xxx, 0, 0, true ],
    s7: [ :xxx, :xxx, 0, 0, true ],
    s8: [ :xxx, :xxx, 0, 0, true ],
    s9: [ :xxx, :xxx, 0, 0, true ]
  }
}



i = 0
mds.each do |md, games|
  puts "key: ", md
  puts "value: ", games
  i += 1
  puts "Matchday: #{i}"
  j = 0
  if m = masterseason.matchdays.find_by_number(i)
    puts "before: "
    games.each do |game|
      j += 1
      s0 = game[1][0].to_sym
      s1 = game[1][1].to_sym
      t0 = Team.find_by_name(teams[s0][:name])
      t1 = Team.find_by_name(teams[s1][:name])
      FactoryGirl.create :game, home: t0, guest: t1, home_goals: game[1][2], 
                guest_goals: game[1][3], finished: game[1][4], date: (m.date+1.day), matchday: m
    end
  else
    puts "Matchday: #{i} not found!"
  end
end
