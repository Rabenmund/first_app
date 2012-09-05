#!/bin/env ruby
# encoding: utf-8

require "spec_helper"
include SessionsHelper

describe SessionsController do
  
  let(:user) { create :user }
  
  subject { controller }

  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
    
    describe :new do
      describe :active_filter do
        after { get :new }
        specify { controller.should_not_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
    end
    
    describe :create do
      describe :active_filter do
        after { post :create, session: { auth: user.nickname, password: user.password } }
        specify { controller.should_not_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid_with_nickname do
        before { post :create, session: { auth: user.nickname, password: user.password } }
        specify { current_user?(user).should be_true }
        specify { response.should redirect_to home_path }
      end
      describe :valid_with_email do
        before { post :create, session: { auth: user.email, password: user.password } }
        specify { current_user?(user).should be_true }
        specify { response.should redirect_to home_path }
      end
      describe :invalid_with_user do
        before { post :create, session: { auth: "Invalid", password: user.password } }
        specify { current_user?(user).should_not be_true }
        it { should render_template "new" }
      end
      describe :invalid_with_password do
        before { post :create, session: { auth: user.nickname, password: "Invalid" } }
        specify { current_user?(user).should_not be_true }
        it { should render_template "new" }
      end
    end
    
    describe :destroy do
      describe :active_filter do
        after { delete :destroy, id: user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_receive(:correct_user) }
      end
      before { delete :destroy, id: user.id }
      specify { current_user?(user).should_not be_true }
      it { should redirect_to landing_path }
    end
    
  end
end