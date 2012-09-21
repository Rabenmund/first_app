#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Game do
  
  let(:season)  { create :full_season }
  let(:game)    { build :game }
  subject { game }
  
  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:home_goals).of_type(:integer) }
    it { should have_db_column(:guest_goals).of_type(:integer) }
    it { should have_db_column(:date).of_type(:datetime) }
    it { should have_db_column(:matchday_id).of_type(:integer) }
    it { should have_db_column(:home_id).of_type(:integer) }
    it { should have_db_column(:guest_id).of_type(:integer) }
  end
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :home_goals }
    it { should allow_mass_assignment_of :guest_goals }
    it { should allow_mass_assignment_of :matchday_id }
    it { should allow_mass_assignment_of :home_id }
    it { should allow_mass_assignment_of :guest_id }
    it { should allow_mass_assignment_of :date }
  end
  
  describe :associations do
    it { should belong_to :matchday }
    it { should belong_to :home }
    it { should belong_to :guest }
    it { should have_one  :season }
  end
  
  describe :validations do
    it { should validate_presence_of :date }
    it { should validate_presence_of :home_id }
    it { should validate_presence_of :guest_id }
    it { should validate_presence_of :matchday_id }
    
    describe "should have a home team associated to season" do
      describe :true do
        specify { game.season.teams.should include game.home }
      end
      describe :false do
        before { game.season.teams.delete(game.home)}
        it { should_not be_valid }
        specify { expect{game.save!}.to raise_error(/gehört nicht zur Saison/)}
      end
    end
    describe "should have a guest team associated to season" do
      describe :true do
        specify { game.season.teams.should include game.guest }
      end
      describe :false do
        before { game.season.teams.delete(game.guest)}
        it { should_not be_valid }
        specify { expect{game.save!}.to raise_error(/gehört nicht zur Saison/)}
      end
    end
    describe "should have a date in seasons date range" do
      describe :true do
        it { should be_valid }
      end
      describe :false do
        before { game.update_attribute("date", DateTime.now - 10.years)}
        it { should_not be_valid }
        specify { expect { game.save! }.to raise_error (/liegt nicht im Datumsbereich der Saison/)}
      end
    end
    # describe :home_not_used_in_matchday do
    #   before { game.save! }
    #   describe :true do
    #     before { @game2 = build :game, matchday: game.matchday }
    #     it { @game2.should be_valid }
    #   end
    #   describe :false do
    #     before { @game2 = build :game, matchday: game.matchday, home: game.home }
    #     it { should_not be_valid }
    #     specify { expect { @game2.save! }.to raise_error (/wird bereits in einem anderen Spiel des Spieltages verwendet/)}
    #   end
    # end
    # describe :guest_not_used_in_matchday do
    #   before { game.save! }
    #   describe :true_different_teams do
    #     before { @game2 = build :game, matchday: game.matchday }
    #     it { @game2.should be_valid }
    #   end
    #   describe :true_different_matchday do
    #     before { @game2 = build :game, home: game.home, guest: game.guest }
    #     it { @game2.should be_valid }
    #   end
    #   describe :false do
    #     before { @game2 = build :game, matchday: game.matchday, guest: game.home }
    #     it { @game2.should_not be_valid }
    #     specify { expect { @game2.save! }.to raise_error (/wird bereits in einem anderen Spiel des Spieltages verwendet/)}
    #   end
    # end
    # describe :game_not_used_in_season do
    #   before do 
    #     game.save!
    #     @matchday2 = create :matchday, season: matchday.season
    #   end
    #   describe :true_different_game do
    #     before { @game2 = build :game, matchday: game.matchday }
    #     specify { @game2.matchday.season.should eq game.matchday.season}
    #     it { @game2.should be_valid }
    #   end
    #   describe :true_different_season do
    #     before { @game2 = build :game, home: game.home, guest: game.guest }
    #     specify { @game2.matchday.season.should_not eq game.matchday.season}
    #     it { @game2.should be_valid }
    #   end
    #   describe :false do
    #     before { @game2 = build :game, matchday: @matchday2, home: game.home, guest: game.home }
    #     it { @game2.should_not be_valid }
    #     specify { expect { @game2.save! }.to raise_error (/existiert bereits an einem anderen Spieltag der Saison: /)}
    #   end
    # end
  end
  
  describe :methods do
    
    describe :teams do
      subject { game.teams }
      it { should include(game.home) }
      it { should include(game.guest) }
    end
    
  end
      
  
end
