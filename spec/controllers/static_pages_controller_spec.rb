#!/bin/env ruby
# encoding: utf-8

require "spec_helper"
include SessionsHelper

describe StaticPagesController do
  
  let(:user) { create :user }
  before { sign_in(user) }
  
  subject { controller }

  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
    
    describe :home do
      describe :active_filter do
        after { get :home }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :home }
      it { should assign_to :micropost }
      it { should assign_to :feed_items }
    end
    
    describe :landing do
      describe :active_filter do
        after { get :landing }
        specify { controller.should_not_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
    end
    
    describe :help do
      describe :active_filter do
        after { get :help }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
    end
    
    describe :about do
      describe :active_filter do
        after { get :about }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
    end
    
    describe :contact do
      describe :active_filter do
        after { get :contact }
        specify { controller.should_not_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
    end
  end
end