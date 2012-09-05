require 'spec_helper'

describe User do

  let(:user) { build :user }
  subject { user }

  describe :attributes do
    it { should be_valid }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:remember_token).of_type(:string) }
    it { should have_db_column(:admin).of_type(:boolean) }
    it { should have_db_column(:deactivated).of_type(:boolean) }
    it { should have_db_column(:nickname).of_type(:string) }
    it { should_not have_db_column :password }
    it { should_not have_db_column :password_confirmation }
    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:nickname).unique(true) }
    it { should have_db_index(:remember_token) }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
  end
  
  describe :mass_assignment do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :nickname }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :password }
    it { should allow_mass_assignment_of :password_confirmation }
    it { should_not allow_mass_assignment_of :password_digest }
    it { should_not allow_mass_assignment_of :remember_token }
    it { should_not allow_mass_assignment_of :deactivated }
    it { should_not allow_mass_assignment_of :admin }
  end
  
  describe :associations do
    it { should have_many(:microposts) }
    it { should have_and_belong_to_many :seasons }
  end
  
  describe :validations do
    it { should validate_presence_of :name }
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :email }
    it { User.create.should validate_presence_of :password_confirmation } #on create
    it { User.create.should validate_presence_of :password }              #on create
    it { User.create.should ensure_length_of(:password).is_at_least(6) }
    it { should ensure_length_of(:name).is_at_least(5).is_at_most(20) }
    it { should ensure_length_of(:nickname).is_at_least(5).is_at_most(20) }
    describe "should validate_uniqueness_of email and nickname" do
      before { user.save }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_uniqueness_of(:nickname).case_insensitive }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |invalid_address|
          user.email = invalid_address
          user.should_not be_valid
        end      
      end
    end
    
    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          user.email = valid_address
          user.should be_valid
        end      
      end
    end
  end
    
  describe :before_save do
    
    describe :downcase_email do
      before do
        @before_email = "UpAnDoWn@example.com"
        @user = build(:user, email: @before_email)
        @user.save
      end
      specify { @user.email.should eq @before_email.downcase }
    end
    
    describe :deactivate do
      describe :initially do
        before { @user = build(:user) }
        specify { @user.deactivated.should be_nil }
      end
      describe :after_save do
        before { user.save }
        specify { user.deactivated.should be_true }
      end
    end
    
    describe :remember_token do
      before { user.save }
      its(:remember_token) { should_not be_blank }
    end
  end
  
  describe :methods do
    
    describe :is_admin? do
      describe :true do
        let(:admin) { create :admin }
        specify { admin.is_admin?.should be_true }
      end
      describe :false do
        specify { user.is_admin?.should be_false }
      end
    end
    
    describe :name_role do
      describe :for_user do
        it { user.name_role.should eq user.name }
      end
      describe :for_admin do
        let(:admin) { create :admin }
        specify { admin.name_role.should eq "#{admin.name} "+"(admin)"}
      end
    end
    
    describe :activate! do
      before { user.activate! }
      specify { user.deactivated.should be_false }
    end
    
    describe :activated? do
      before { user.save }
      describe :true do
        before { user.activate! }
        specify { user.activated?.should be_true }
      end
      describe :false do
        specify { user.activated?.should be_false }
      end
    end
  
    describe :deactivate! do
      before { user.deactivate! }
      specify { user.deactivated.should be_true }
    end
    
    describe :deactivated? do
      before { user.save }
      describe :true do
        before { user.activate! }
        specify { user.deactivated?.should be_false }
      end
      describe :false do
        specify { user.deactivated?.should be_true }
      end
    end
  end
end