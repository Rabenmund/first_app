#!/bin/env ruby
# encoding: utf-8
require "spec_helper"

describe UsersController do
  
  let(:user) { create :user }
  subject { controller }
  
  describe :filter do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
      
    describe :check_admin do
      describe :admin do
        let(:admin) { create :admin }
        before { get :activate, id: admin.id }
        it { should set_the_flash.to "#{admin.name} ist ein Admin und kann nicht aktiviert werden." }
        it { should redirect_to users_path }
      end
      describe :user do
        before { get :activate, id: user.id }
        it { should_not set_the_flash.to "#{user.name} ist ein Admin und kann nicht aktiviert werden." }
      end
    end
  end
  
  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
      controller.stub(:check_admin).and_return(true)
    end
    
    describe :new do
      describe :active_filter do
        after { get :new }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      before { get :new }
      it { should assign_to :user }
      specify { controller.instance_variable_get("@user").deactivated?.should be_true }
    end
    
    describe :index do
      describe :active_filter do
        after { get :index }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      before { get :index }
      it { should assign_to :users }
      it { should assign_to :activated_users }
      it { should assign_to :deactivated_users }
    end
    
    describe :create do
      describe :active_filter do
        after { post :create, user: attributes_for(:user) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      describe :valid do
        before { post :create, user: attributes_for(:user) }
        it { should assign_to :user }
        specify { response.should redirect_to User.last }
        it { expect { post :create, user: attributes_for(:user) }.to change(User, :count).by(1)}
      end
      describe :invalid do
        before { post :create, user: {} }
        it { should render_template "new" }
        it { expect { post :create, user: {} }.to change(User, :count).by(0)}
      end
    end
    
    describe :edit do
      describe :active_filter do
        after { get :edit, id: user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      before { get :edit, id: user.id }
      it { should assign_to :user }
    end
    
    describe :destroy do
      before { @user = create :user }
      describe :active_filter do
        after { delete :destroy, id: @user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      describe :valid do
        before { delete :destroy, id: @user.id  }
        it { should set_the_flash.to "#{@user.name} wurde gelöscht." }
        specify { response.should redirect_to users_path }
        it { expect { @user = create :user; delete :destroy, id: @user.id  }.to change(User, :count).by(0)}
      end
      describe :invalid do
        before do
          User.any_instance.stub(:destroy).and_return(false)
          delete :destroy, id: @user.id 
        end
        it { should set_the_flash.to "#{@user.name} konnte nicht gelöscht werden." }
        specify { response.should redirect_to user_path(@user) }
        it { expect { delete :destroy, id: @user.id  }.to change(User, :count).by(0)}
      end
    end
    
    describe :update do
      before { @user = create :user }
      describe :active_filter do
        after { put :update, id: @user.id, user: attributes_for(:user) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      describe :valid do
        before { put :update, id: @user.id, user: attributes_for(:user).merge(name: "Other Name")  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, id: @user.id, user: attributes_for(:user).merge(name: "X") }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      describe :active_filter do
        after { get :show, id: user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_not_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      before { get :show, id: user.id }
      it { should assign_to :user }
    end
    
    describe :deactivate do
      describe :active_filter do
        after { get :deactivate, id: user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_not_receive(:check_admin) }
      end
      describe :valid do
        before do
          @user = create :user
          get :deactivate, id: @user.id
        end
        it { should set_the_flash.to "#{@user.name} deaktiviert" }
        specify { response.should redirect_to users_path }
      end
      describe :invalid do
        before do
          @user = create :user
          @user.activate!
          User.any_instance.stub(:deactivate!).and_return(false)
          get :deactivate, id: @user.id
        end
        it { should set_the_flash.to "#{@user.name} konnte nicht deaktiviert werden" }
        specify { response.should redirect_to users_path }
      end
    end
    
    describe :activate do
      describe :active_filter do
        after { get :activate, id: user.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:check_admin) }
      end
      describe :valid do
        before do
          @user = create :user
          get :activate, id: @user.id
        end
        it { should set_the_flash.to "#{@user.name} aktiviert" }
        specify { response.should redirect_to users_path }
      end
      describe :invalid do
        before do
          @user = create :user
          User.any_instance.stub(:activate!).and_return(false)
          get :activate, id: @user.id
        end
        it { should set_the_flash.to "#{@user.name} konnte nicht aktiviert werden" }
        specify { response.should redirect_to users_path }
      end
    end
  end  
end