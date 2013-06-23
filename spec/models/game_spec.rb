#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Game do
  
  let(:season)  { create :full_season }
  let(:game)    { build :game }
  let(:matchday) { game.matchday }
  subject { game }
  
  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:home_goals).of_type(:integer) }
    it { should have_db_column(:guest_goals).of_type(:integer) }
    it { should have_db_column(:date).of_type(:datetime) }
    it { should have_db_column(:matchday_id).of_type(:integer) }
    it { should have_db_column(:home_id).of_type(:integer) }
    it { should have_db_column(:guest_id).of_type(:integer) }
    it { should have_db_column(:finished).of_type(:boolean) }
  end
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :home_goals }
    it { should allow_mass_assignment_of :guest_goals }
    it { should allow_mass_assignment_of :matchday_id }
    it { should allow_mass_assignment_of :home_id }
    it { should allow_mass_assignment_of :guest_id }
    it { should allow_mass_assignment_of :date }
    it { should allow_mass_assignment_of :finished }
  end
  
  describe :associations do
    it { should belong_to :matchday }
    it { should belong_to :home }
    it { should belong_to :guest }
    it { should have_one  :season }
    it { should have_many(:tipps).dependent(:destroy) }
    it { should have_many(:users).through(:season) }
  end
  
  describe :validations do
    it { should validate_presence_of :date }
    it { should validate_presence_of :home_id }
    it { should validate_presence_of :guest_id }
    it { should validate_presence_of :matchday_id }
    
    describe "should have a home team associated to season" do
      describe :true do
        specify { game.should be_valid }
      end
      describe :false do
        before do
          @game = create :game
          @game.season.teams.delete(@game.home)
        end
        specify { @game.should_not be_valid }
        specify { expect{@game.save!}.to raise_error(/gehört nicht zur Saison/)}
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
    
    describe :game_count do
      let(:matchday) { create :matchday }
      describe "lower than 9 games threshold" do
        before do
          matchday.games.stub(:count).and_return(9)
          @game = create :game, matchday: matchday
        end
        it { should be_valid }
      end
      describe "9 games or more" do
        before do
          matchday.games.stub(:count).and_return(10)
          @game = build :game, matchday: matchday
        end
        specify { expect { @game.save! }.to raise_error (/hat bereits 9 Spiele/)}
      end
    end
    
    describe :home_unique_at_matchday do
      before do 
        @matchday = create :matchday
        @game1 = create :game, matchday: @matchday
        @matchday.games << @game1
      end
      describe :true do
        before do
          @game2 = build :game, matchday: @matchday
          @matchday.games << @game2
          @game2.save
        end
        it { @game2.should be_valid }
      end
      describe :false do
        before do
          @game2 = build :game, matchday: @matchday, home: @game1.home
          @matchday.games << @game2
        end
        it { @game2.should_not be_valid }
        specify { expect { @game2.save! }.to raise_error (/wird bereits an dem Spieltag verwendet/)}
      end
    end
    
    describe :guest_unique_at_matchday do
      before do 
        @matchday = create :matchday
        @game1 = create :game, matchday: @matchday
        @matchday.games << @game1
      end
      describe :true_different_teams do
        before do
          @game2 = build :game, matchday: @matchday
          @matchday.games << @game2
          @game2.save
        end
        it { @game2.should be_valid }
      end
      describe :true_different_matchday do
        before { @game2 = build :game, home: @game1.home, guest: @game1.guest }
        it { @game2.should be_valid }
      end
      describe :false do
        before do
          @game2 = build :game, matchday: @matchday, guest: @game1.guest
          @matchday.games << @game2
        end
        it { @game2.should_not be_valid }
        specify { expect { @game2.save! }.to raise_error (/wird bereits an dem Spieltag verwendet/)}
      end
    end
    
    describe :home_not_guest do
      describe :false do
        it { game.should be_valid }
      end
      describe :true do
        before { game.home = game.guest }
        it { game.should_not be_valid }
        specify { expect { game.save! }.to raise_error (/darf nicht gleich Gast sein./)}
      end
    end

  end
  
  describe :method do
    
    before { game.save! }
    
    describe :teams do
      subject { game.teams }
      it { should include(game.home) }
      it { should include(game.guest) }
    end
    
    context :active do
      subject { Game.active }
      describe "with a non-finished game" do
        before do
          @active_game = create :game, finished: false, date: DateTime.now+1.day
          @finished_game = create :game, finished: true, date: DateTime.now+1.day
        end
        it { should include(@active_game) }
        it { should_not include(@finished_game) }
      end
      describe "with all game finished" do
        before { @finished_game = create :game, finished: true, date: DateTime.now+1.day }
        it { should_not include(@finished_game) }
      end
      describe "with a date before now" do
        before { @outdated_game = create :game, finished: false, date: DateTime.now-1.day }
        it { should_not include(@outdated_game) }
      end
    end
    
    context :has_wday_humanize do
      it { game.date = "2.1.2012"; game.has_wday_humanize.should eq "Montag" }
      it { game.date = "3.1.2012"; game.has_wday_humanize.should eq "Dienstag" }
      it { game.date = "4.1.2012"; game.has_wday_humanize.should eq "Mittwoch" }
      it { game.date = "5.1.2012"; game.has_wday_humanize.should eq "Donnerstag" }
      it { game.date = "6.1.2012"; game.has_wday_humanize.should eq "Freitag" }
      it { game.date = "7.1.2012"; game.has_wday_humanize.should eq "Samstag" }
      it { game.date = "8.1.2012"; game.has_wday_humanize.should eq "Sonntag" }
    end
    
    context :tipp_of do
      before { @tipp = create :tipp, game: game }
      subject { game.tipp_of(@tipp.user) }
      it { should eq @tipp }
    end
    
    context :can_be_tipped? do
      describe "and is finished" do
        before { @game = create :game, finished: true }
        subject { @game.can_be_tipped? }
        it { should be_false }
      end
      describe "a game in the future?" do
        before { @game = create :game, date: DateTime.now+1.day }
        subject { @game.can_be_tipped? }
        it { should be_true }
      end
      describe "a game in the past?" do
        before { @game = create :game, date: DateTime.now-1.day }
        subject { @game.can_be_tipped? }
        it { should be_false }
      end
    end
    
    context :finished? do
      subject { game.finished? }
      describe :finished_flag_set do
        before { game.finished = true; game.save! }
        it { should be_true }
      end
      describe :finished_flag_unset do
        before { game.finished = false; game.save! }
        it { should be_false }
      end
    end
    
    context :started? do
      subject { game.started? }
      describe :game_date_reached do
        before do
          t = game.date.time
          Timecop.travel(t)
        end
        it { should be_true }
      end
      describe :before_game_date do
        it { should be_false }
      end
    end
    
    context :has_result? do
      subject { game.has_result? }
      describe :with_no_goals do
        it { should be_false }
      end
      describe :with_home_goals_only do
        before { game.home_goals = 1; game.save! }
        it { should be_false }
      end
      describe :with_guest_goals_only do
        before { game.guest_goals = 1; game.save! }
        it { should be_false }
      end
      describe :with_both_goals do
        before { game.home_goals, game.guest_goals = 1,1; game.save! }
        it { should be_true}
      end
    end
    
    context :has_final_result? do
      subject { game.has_final_result? }
      describe :with_no_goals_and_not_finished do
        it { should be_false }
      end
      describe :with_no_goals_and_finished do
        before { game.finished = true; game.save! }
        it { should be_false }
      end
      describe :with_goals_and_not_finished do
        before { game.home_goals, game.guest_goals = 1,1; game.save! }
        it { should be_false }
      end
      describe :with_goals_and_finished do
        before { game.home_goals, game.guest_goals, game.finished = 1,1, true; game.save! }
        it { should be_true }
      end
    end
    
    context :recalc_tipps! do
      subject { game.recalc_tipps! }
      describe :no_tipps do
        it { should be_true }
      end
      describe :with_tipps do
        let(:tipp) { create :tipp }
        before do
          game.stub(:tipps).and_return([tipp, tipp])
          tipp.stub(:set_points).and_return(5)
        end
        describe :tipp_save_ok do
          before { Tipp.any_instance.should_receive(:save).with(validate: false).exactly(2).times.and_return(true)}
          it { should be_true }
        end
      end 
    end
    
    context :recalc_results! do
      pending
    end
    
  end
    
end
