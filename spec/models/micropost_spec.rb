require 'spec_helper'

describe Micropost do

  let(:micropost) { create :micropost }
  
  subject { micropost }

  describe :attributes do
    it { should be_valid }
    it { should respond_to :content }
    it { should respond_to :user_id }
    it { should allow_mass_assignment_of :content }
    it { should_not allow_mass_assignment_of :user_id }
  end
    
  describe :associations do
    it { should belong_to(:user) }
  end
  
  describe :validations do
    it { should validate_presence_of :content }
    it { should validate_presence_of :user_id }
    it { should ensure_length_of(:content).is_at_most(Micropost::MICROPOST_MAX_CHAR) }
  end
  
  describe :db do
    it { should have_db_column(:content).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_index([:user_id, :created_at]) }
  end
  
  describe :constants do
    specify { Micropost::MICROPOST_MAX_CHAR.should eq 200 }
  end

end
