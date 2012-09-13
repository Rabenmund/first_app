require 'spec_helper'

describe ApplicationHelper do

  describe :full_title do
    describe :with_page_title do
      subject { full_title "foo" }
      it { should =~ /foo/ }
      it { should =~ /^Mein.Programm/ }
    end
    describe :without_page_title do
      subject { full_title("") }
      it { should eq "Mein.Programm" } 
    end
  end

end