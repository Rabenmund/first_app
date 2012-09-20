require 'spec_helper'

describe Season do

  let(:season) { build :season }
  subject { season }

  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:start_date).of_type(:datetime) }
    it { should have_db_column(:end_date).of_type(:datetime) }
  end 
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :start_date }
    it { should allow_mass_assignment_of :end_date }
  end
  
  describe :associations do
    it { should have_and_belong_to_many(:teams) }
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:matchdays) }
    it { should have_many(:games) }
  end
  
  describe :validations do
    it { should validate_presence_of :name }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }
    
    describe :start_before_end_date do
      describe :start_before_end do
        before { @season = build :season }
        subject { @season }
        it { should be_valid }
      end
      describe :start_is_end_date do
        before do
          equal_date = DateTime.now
          @season = build :season, start_date: equal_date, end_date: equal_date
        end
        subject { @season }
        it { should be_valid }
      end
      describe :start_after_end_date do
        before { @season = build :season, start_date: DateTime.now + 1.day, end_date: DateTime.now }
        subject { @season }
        it { should_not be_valid }
        specify { expect{@season.save!}.to raise_error(/muss vor dem Saisonende liegen/)}
      end
    end
  end

  describe :methods do
    
    describe :next_matchday_number do
      describe :no_matchdays do
        subject { season.next_matchday_number }
        it { should be 1 } 
      end
      # describe :less_than_34_matchdays do
      #   before { @matchday = create :matchday }
      #   subject { @matchday.season.next_matchday_number }
      #   it { should eq @matchday.number + 1 }
      # end
      describe :matchdays_34 do
        before do
          @season = create :season
          34.times do |n|
            matchday = create :matchday, number: (n+1), season: @season
          end
        end
        subject { @season.next_matchday_number }
        it { should be_nil }
      end
    end
    
    describe :next_matchday_date do
      describe :no_matchdays do
        before { @date = season.next_matchday_date }
        it { @date.wday.should eq 5 }
      end
      describe :matchday_date_exists do
        before do
          @matchday = create :matchday, date: Date.today
          @date = @matchday.season.next_matchday_date
        end
        it { @date.wday.should eq 5 }      
      end
    end
    
    describe :put_all_in_fri_row! do
      describe :no_more_matchdays do
        before { @matchday = create :matchday }
        subject { @matchday.season.put_all_in_fri_row!(@matchday) }
        it { should eq [] }
      end
      describe :full_number_of_matchdays do
        before do
          @season = create :season
          @matchday = create :matchday, season: @season, number: 1
          33.times do |n|
            matchday = create :matchday, number: (n+2), season: @season
          end
          @season.put_all_in_fri_row!(@matchday)
        end
        specify { @season.matchdays.find_by_number(3).date.should eq @season.matchdays.find_by_number(2).date + 7.days }
        specify { @season.matchdays.find_by_number(34).date.wday.should eq 5 }
      end
    end
    
  end
end
    
    
