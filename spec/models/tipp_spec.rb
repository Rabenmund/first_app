require 'spec_helper'

describe Tipp do
#  pending "add some examples to (or delete) #{__FILE__}"
  
  let(:tipp) { build :tipp }
  subject { tipp }
  
  describe :attributes do
    it { should be_valid }
  end
  
  describe :validations do
    
    context :game_can_be_tipped do
      describe "with a future-dated game is true" do
        before { @good_tipp = build :tipp, game: (create :game, date: DateTime.now + 1.day) }
        it { @good_tipp.should be_valid }
      end
      describe "with a past-dated game is false" do
        before { @bad_tipp = build :tipp, game: (create :game, date: DateTime.now - 1.day) }
        it { @bad_tipp.should_not be_valid }
        specify { expect{@bad_tipp.save!}.to raise_error(/nicht mehr getippt werden/)}
      end
    end
    
  end
  
  describe :method do
    context :active do
      subject { Tipp.active }
      describe "with an non-finished tipp" do
        before do
          @active_tipp = create :tipp, game: (create :game, date: DateTime.now+1.day)
          @finished_tipp = create :tipp, game: (create :game, finished: true, date: DateTime.now+1.day)
        end
        it { should include(@active_tipp) }
        it { should_not include(@finished_tipp) }
      end
      describe "with all tipp finished" do
        before { @finished_tipp = create :tipp, game: (create :game, finished: true, date: DateTime.now+1.day) }
        it { should_not include(@finished_tipp) }
        it { should eq [] }
      end
      describe "with a date before now" do
        before do
          Tipp.any_instance.stub(:game_can_be_tipped).and_return :true
          @outdated_tipp = create :tipp, game: (create :game, finished: false, date: DateTime.now-1.day)
        end
        it { should_not include(@outdated_tipp) }
      end
    end
    
  end
end
