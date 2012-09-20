require 'spec_helper'

describe Team do

  let(:team) { build :team }
  subject { team }

  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:name).of_type(:string) }
  end
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :name }
  end
  
  describe :associations do
    it { should have_and_belong_to_many :seasons }
    it { should have_many :home_games }
    it { should have_many :guest_games }
  end
  
  describe :validations do
    it { should validate_presence_of :name }
    it { should ensure_length_of(:name).is_at_least(5).is_at_most(25) }
    
    describe :uniqueness do
      before { team.save }
      it { should validate_uniqueness_of(:name).case_insensitive }
    end
    
  end
  
  describe :befores do
  end
  
  describe :methods do
    
    describe :games do
      let(:g) { create :game } 
      it { g.home.games.should eq [g] }  
      it { g.guest.games.should eq [g] }   
    end 
    
    describe :games_per_season do
      before do
        @g1 = create :game
        @g2 = create :game, home: @g1.home, guest: @g1.guest 
      end
      it { @g1.home.games.should eq [@g1, @g2] }
      it { @g1.home.games_per_season(@g1.season).should eq [@g1] }
      it { @g1.home.games_per_season(@g2.season).should eq [@g2] }
    end
  end
  
end
