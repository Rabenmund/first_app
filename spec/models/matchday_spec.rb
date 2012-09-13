#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Matchday do

  let(:matchday) { build :matchday }
  subject { matchday }

  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:number).of_type(:integer) }
    it { should have_db_column(:date).of_type(:datetime) }
  end
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :number }
    it { should allow_mass_assignment_of :date }
  end
  
  describe :associations do
    it { should belong_to :season }
  end
  
  describe :validations do
    it { should validate_presence_of :number }
    it { should validate_numericality_of :number }
    it { should validate_presence_of :date }
    
    describe :date_in_date_range do
      describe :date_in_range do
        before do 
          @season = create :season, start_date: DateTime.now - 1.day, end_date: DateTime.now + 1.day
          @matchday = build :matchday, season: @season, date: DateTime.now
        end
        subject { @matchday }
        it { should be_valid }
      end
      describe :date_out_of_range_before_start do
        before do 
          @season = create :season, start_date: DateTime.now - 1.day, end_date: DateTime.now + 1.day
          @matchday = build :matchday, season: @season, date: DateTime.now - 2.day
        end
        subject { @matchday }
        it { should_not be_valid }
        specify { expect{@matchday.save!}.to raise_error(/muss im Datumsbereich der Saison liegen/)}
      end
      describe :date_out_of_range_after_end do
        before do 
          @season = create :season, start_date: DateTime.now - 1.day, end_date: DateTime.now + 1.day
          @matchday = build :matchday, season: @season, date: DateTime.now + 2.day
        end
        subject { @matchday }
        it { should_not be_valid }
        specify { expect{@matchday.save!}.to raise_error(/muss im Datumsbereich der Saison liegen/)}
      end
    end 
    
    describe :date_in_order do
      describe :date_correct do
        before do 
          @season = create :season, start_date: DateTime.now, end_date: DateTime.now + 1.year
          @matchday_before = create :matchday, season: @season, number: 1, date: DateTime.now + 2.days
          @matchday_before = create :matchday, season: @season, number: 3, date: DateTime.now + 4.days
          @matchday = build :matchday, season: @season, number: 2, date: DateTime.now + 3.days
        end
        subject { @matchday }
        it { should be_valid }
      end
      describe :date_earlier_than_matchday_before do
        before do 
          @season = create :season, start_date: DateTime.now, end_date: DateTime.now + 1.year
          @matchday_before = create :matchday, season: @season, number: 1, date: DateTime.now + 2.days
          @matchday_before = create :matchday, season: @season, number: 3, date: DateTime.now + 4.days
          @matchday = build :matchday, season: @season, number: 2, date: DateTime.now + 1.day
        end
        subject { @matchday }
        it { should_not be_valid }
        specify { expect{@matchday.save!}.to raise_error(/vor dem früheren Spieltag/)}
      end
      describe :date_later_than_matchday_after do
        before do 
          @season = create :season, start_date: DateTime.now, end_date: DateTime.now + 1.year
          @matchday_before = create :matchday, season: @season, number: 1, date: DateTime.now + 2.days
          @matchday_before = create :matchday, season: @season, number: 3, date: DateTime.now + 4.days
          @matchday = build :matchday, season: @season, number: 2, date: DateTime.now + 5.days
        end
        subject { @matchday }
        it { should_not be_valid }
        specify { expect{@matchday.save!}.to raise_error(/nach dem späteren Spieltag/)}
      end
    end
  end
  
  describe :befores do
  end
  
  describe :methods do
    
    describe :is_wday? do
      describe :true do
        before { matchday.date="8.9.2012" }
        it { matchday.is_wday?(6).should be_true}
      end
      describe :false do
        before { matchday.date="7.9.2012" }
        it { matchday.is_wday?(6).should be_false}
      end
    end
    
    describe :has_wday_humanize do
      describe :all_days do
        before do
          @matchday = create :matchday
          @matchday.date="9.9.2012"
        end
        specify do
          wochentag = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
          [0,1,2,3,4,5,6].each do |w|
            @matchday.has_wday_humanize.should == wochentag[w]
             @matchday.update_attribute(:date, @matchday.date + 1.day)
          end
        end
      end
    end
  end
  
end
