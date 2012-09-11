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
  end
  
  describe :validations do
    it { should validate_presence_of :name }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }
  end

end
    
    
