#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe SeasonsController do
  
  let(:season) { create :season }
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
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :new }
      it { should assign_to :season }
    end
    
    describe :index do
      describe :active_filter do
        after { get :index }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :index }
      it { should assign_to :seasons }
    end
    
    describe :create do
      describe :active_filter do
        after { post :create, season: attributes_for(:season) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { post :create, season: attributes_for(:season) }
        it { should assign_to :season }
        specify { response.should redirect_to Season.last }
        specify { Season.last.matchdays.count.should eq 34 }
        it { expect { post :create, season: attributes_for(:season) }.to change(Season, :count).by(1)}
        it { expect { post :create, season: attributes_for(:season) }.to change(Matchday, :count).by(34)}
      end
      describe :invalid do
        before { post :create, season: {} }
        it { should render_template "new" }
        it { expect { post :create, season: {} }.to change(Season, :count).by(0)}
      end
    end
    
    describe :edit do
      describe :active_filter do
        after { get :edit, id: season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :edit, id: season.id }
      it { should assign_to :season }
    end
    
    describe :destroy do
      before { @season = create :season }
      describe :active_filter do
        after { delete :destroy, id: @season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { delete :destroy, id: @season.id  }
        it { should set_the_flash.to "#{@season.name} wurde gelöscht." }
        specify { response.should redirect_to seasons_path }
        it { expect { @season = create :season; delete :destroy, id: @season.id  }.to change(Season, :count).by(0)}
      end
      describe :invalid do
        before do
          Season.any_instance.stub(:destroy).and_return(false)
          delete :destroy, id: @season.id 
        end
        it { should set_the_flash.to "#{@season.name} konnte nicht gelöscht werden." }
        specify { response.should redirect_to season_path(@season) }
        it { expect { delete :destroy, id: @season.id  }.to change(Season, :count).by(0)}
      end
    end
    
    describe :update do
      before { @season = create :season }
      describe :active_filter do
        after { put :update, id: @season.id, season: attributes_for(:season) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { put :update, id: @season.id, season: attributes_for(:season).merge(name: "Other Name")  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, id: @season.id, season: attributes_for(:season).merge(name: nil) }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      describe :active_filter do
        after { get :show, id: season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :show, id: season.id }
      it { should assign_to :season }
    end
  end
  
  
end
