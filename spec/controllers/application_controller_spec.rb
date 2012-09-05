#!/bin/env ruby
# encoding: utf-8

require "spec_helper"
include SessionsHelper

describe MicropostsController do
  
  let(:user) { create :user }
  
  controller do
    
    # Anonymous dummy controller inherited from application controller
    # to test application controllers methods that are used
    # in application controller only, like the filter methods.
    # A dummy action (here: :index) provides access to those methods.
    
    def index
      head :success
    end
  end
  
  describe :filter do
    
    describe :authenticate do
      before do
       controller.stub(:admin).and_return(true)
       controller.stub(:correct_user).and_return(true)
      end
      describe :not_signed_in do
        before { get :index }
        it { should set_the_flash.to 'Bitte melde dich an !' }
        specify { response.should redirect_to new_session_path }
      end
      describe :signed_in_but_deactivated do
       before do
         sign_in user
         User.any_instance.stub(:deactivated?).and_return(true)
         get :index
       end
       it { should set_the_flash.to 'Bitte melde dich mit einem gültigen Benutzer an!' }
       specify { response.should redirect_to new_session_path }
      end
      describe :is_admin do
        before do
         @admin = create :admin
         sign_in @admin
         get :index
        end
        specify { response.should_not redirect_to new_session_path }
      end
      describe :signed_in do
        before do
          sign_in user 
          User.any_instance.stub(:deactivated?).and_return(false)
          get :index
        end
        specify { response.should_not redirect_to new_session_path }
      end
    end
    
    describe :admin do
      before do
       controller.stub(:authenticate).and_return(true)
       controller.stub(:correct_user).and_return(true)
      end
      describe :is_admin do
        before do
          @admin = create :admin
          sign_in @admin
          get :index
        end
        specify { response.should_not redirect_to root_path }
      end
      describe :is_not_admin do
        before do
          sign_in user
          get :index
        end
        specify { response.should redirect_to root_path }
      end
    end
    
    describe :correct_user do
      before do
       controller.stub(:authenticate).and_return(true)
       controller.stub(:admin).and_return(true)
      end
      describe :is_correct_user do
        before do
          sign_in user
          get :index, id: user.id
        end
        it { response.should_not redirect_to root_path }
      end
      describe :is_admin do
        before do
          @admin = create :admin
          sign_in @admin
          get :index, id: user.id
        end
        it { response.should_not redirect_to root_path }
      end
      describe :is_not_correct_user do
        before do
          @user2 = create :user
          sign_in @user2
          get :index, id: user.id
        end
        it { response.should redirect_to root_path }
      end
    end
  end
end