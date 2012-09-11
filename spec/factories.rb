FactoryGirl.define do
  factory :user, class: User do
    sequence(:name)           { |n| "TestUser#{n}"}
    email                     { "#{name}@example.com".downcase }
    sequence(:nickname)       { |n| "TestAlias#{n}"}
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
    sequence(:name)           { |n| "TestName#{n}"}
  end
  
  factory :season, class: Season do
    sequence(:name)           { |n| "TestName#{n}"}
    start_date                DateTime.now-1
    end_date                  DateTime.now+1
    factory :season_and_team do
      after :build do |season|
        team = create :team
        season.teams << team
      end
    end
    factory :season_and_user do
      after :build do |season|
        user = create :user
        season.teams << team
      end
    end
  end
  
  factory :matchday, class: Matchday do
    sequence(:number)         { |n| n }
    date                      DateTime.now+1
    season
  end
    
end