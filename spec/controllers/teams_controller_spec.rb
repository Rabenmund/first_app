#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe TeamsController do
  
  let(:team) { create :team }
  subject { controller }
  
  # describe :filter do
  #   before do
  #     controller.stub(:authenticate).and_return(true)
  #     controller.stub(:admin).and_return(true)
  #     controller.stub(:correct_user).and_return(true)
  #   end
  # end
  
  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
    
    describe :new do
      describe :active_filter do
        after { get :new }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :new }
      it { should assign_to :team }
    end
    
    describe :index do
      describe :active_filter do
        after { get :index }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :index }
      it { should assign_to :teams }
    end
    
    describe :create do
      describe :active_filter do
        after { post :create, team: attributes_for(:team) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { post :create, team: attributes_for(:team) }
        it { should assign_to :team }
        specify { response.should redirect_to Team.last }
        it { expect { post :create, team: attributes_for(:team) }.to change(Team, :count).by(1)}
      end
      describe :invalid do
        before { post :create, team: {} }
        it { should render_template "new" }
        it { expect { post :create, team: {} }.to change(Team, :count).by(0)}
      end
    end
    
    describe :edit do
      describe :active_filter do
        after { get :edit, id: team.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :edit, id: team.id }
      it { should assign_to :team }
    end
    
    describe :destroy do
      before { @team = create :team }
      describe :active_filter do
        after { delete :destroy, id: @team.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { delete :destroy, id: @team.id  }
        it { should set_the_flash.to "#{@team.name} wurde gelöscht." }
        specify { response.should redirect_to teams_path }
        it { expect { @team = create :team; delete :destroy, id: @team.id  }.to change(Team, :count).by(0)}
      end
      describe :invalid do
        before do
          Team.any_instance.stub(:destroy).and_return(false)
          delete :destroy, id: @team.id 
        end
        it { should set_the_flash.to "#{@team.name} konnte nicht gelöscht werden." }
        specify { response.should redirect_to team_path(@team) }
        it { expect { delete :destroy, id: @team.id  }.to change(Team, :count).by(0)}
      end
    end
    
    describe :update do
      before { @team = create :team }
      describe :active_filter do
        after { put :update, id: @team.id, team: attributes_for(:team) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { put :update, id: @team.id, team: attributes_for(:team).merge(name: "Other Name")  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, id: @team.id, team: attributes_for(:team).merge(name: "X") }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      describe :active_filter do
        after { get :show, id: team.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :show, id: team.id }
      it { should assign_to :team }
    end
  end
  
  
end
