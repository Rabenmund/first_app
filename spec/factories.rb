FactoryGirl.define do
  factory :user, class: User do
    sequence(:name)           { |n| "UserName#{n}"}
    email                     { "#{name}@example.com".downcase }
    sequence(:nickname)       { |n| "Nickname#{n}"}
    password                  "password"
    password_confirmation     { "#{password}" }
    factory :admin do
      admin                   true
    end
  end
  
  factory :micropost, class: Micropost do
    content                   { Forgery::LoremIpsum.characters(200) }  
    user
  end   
  
  factory :team, class: Team do
    sequence(:name)           { |n| "TeamName#{n}"}
  end
  
  factory :season, class: Season do
    sequence(:name)           { |n| "SeasonName#{n}"}
    start_date                DateTime.now-1.year
    end_date                  DateTime.now+5.year
    finished                  false
    factory :season_and_team do
      after :build do |season|
        team = create :team
        season.teams << team
      end
    end
    factory :season_and_user do
      after :build do |season|
        user = create :user
        season.users << user
      end
    end
    factory :full_season do
      after :build do |season|
        10.times { user = create :user; season.users << user }
        18.times { team = create :team; season.teams << team }
        34.times { |i| md = create :matchday, season: season, date: DateTime.now+1.day+i.day, number: i }
      end
      after :create do |season|
        season.matchdays.each do |md|
          9.times { |i| game = create :game, date: md.date, home: season.teams[i*2], guest: season.teams[(i*2)+1], matchday: md; }
        end
      end
    end
  end
  
  factory :matchday, class: Matchday do
    sequence(:number)         { |n| n }
    date                      DateTime.now
    finished                  false
    season
  end
  
  factory :game, class: Game do
    date                      DateTime.now+1.day
    home_id                   { team = create :team; team.id }
    guest_id                  { team = create :team; team.id }
    finished                  false
    matchday                  
    after :build do |game|
      game.matchday.season.teams << game.home #unless game.matchday.season.teams.includes(game.home)
      game.matchday.season.teams << game.guest #unless game.matchday.season.teams.includes(game.guest)
    end
  end
  
  factory :tipp, class: Tipp do
    user
    game
    after :build do |tipp|
      tipp.game.matchday.season.users << tipp.user
    end
  end
    
end