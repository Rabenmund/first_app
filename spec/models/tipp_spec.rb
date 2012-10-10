require 'spec_helper'

describe Tipp do
  pending "add some examples to (or delete) #{__FILE__}"
  
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
        before { @outdated_tipp = create :tipp, game: (create :game, finished: false, date: DateTime.now-1.day) }
        it { should_not include(@outdated_tipp) }
      end
    end
    
  end
end
