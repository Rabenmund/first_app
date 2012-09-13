#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe MatchdaysController do
  
  let(:matchday) { create :matchday }
  let(:season)   { matchday.season }
  subject { controller }
  
  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
    
    describe :new do
      describe :active_filter do
        after { get :new, season_id: season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:load_season) }
        specify { controller.should_not_receive(:load_matchday) }
      end
      before { get :new, season_id: season.id }
      it { should assign_to :matchday }
    end
    
    describe :index do
      describe :active_filter do
        after { get :index, season_id: season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:load_season) }
        specify { controller.should_not_receive(:load_matchday) }
      end
      before { get :index, season_id: season.id }
      it { should assign_to :matchdays }
    end
    
    describe :create do
      # describe :active_filter do
      #   specify { controller.should_receive(:authenticate) }
      #   specify { controller.should_receive(:admin) }
      #   specify { controller.should_not_receive(:correct_user) }
      #   specify { controller.should_receive(:load_season) }
      #   specify { controller.should_not_receive(:load_matchday) }
      #   after do
      #     post :create, season_id: season.id, matchday: attributes_for(:matchday)
      #   end
      # end
      describe :valid do
        before { post :create, season_id: season.id, matchday: attributes_for(:matchday) }
        it { should assign_to :matchday }
        specify { response.should redirect_to season }
        it { expect { post :create, season_id: season.id, matchday: attributes_for(:matchday)  }.to change(Matchday, :count).by(1)}
      end
      describe :invalid do
        before { post :create, season_id: season.id, matchday: {} }
        it { should render_template "new" }
        it { expect { post :create, season_id: season.id, matchday: {} }.to change(Matchday, :count).by(0)}
      end
    end
    
    describe :edit do
      describe :active_filter do
        after { get :edit, season_id: season.id, id: matchday.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:load_season) }
        specify { controller.should_receive(:load_matchday) }
      end
      before { get :edit, season_id: season.id, id: matchday.id }
      it { should render_template :edit }
    end
    
    # describe :destroy do
    #   before { @matchday = create :matchday }
    #   describe :active_filter do
    #     after { delete :destroy, season_id: @matchday.season.id, id: @matchday.id }
    #     specify { controller.should_receive(:authenticate) }
    #     specify { controller.should_receive(:admin) }
    #     specify { controller.should_not_receive(:correct_user) }
    #     specify { controller.should_receive(:load_season) }
    #     specify { controller.should_receive(:load_matchday) }
    #   end
    #   before { delete :destroy, season_id: @matchday.season.id, id: @matchday.id }
    #   it { should render_template :destroy }
    # end
    
    describe :update do
      before { @matchday = create :matchday}
      # describe :active_filter do
      #   after { put :update, season_id: @matchday.season.id, id: @matchday.id, matchday: attributes_for(:matchday) }
      #   specify { controller.should_receive(:authenticate) }
      #   specify { controller.should_receive(:admin) }
      #   specify { controller.should_not_receive(:correct_user) }
      #   specify { controller.should_receive(:load_season).and_return @matchday.season }
      #   specify { controller.should_receive(:load_matchday).and_return @matchday }
      # end
      describe :valid do
        before { put :update, season_id: @matchday.season.id, id: @matchday.id, matchday: attributes_for(:matchday).merge(number: 2)  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, season_id: @matchday.season.id, id: @matchday.id, matchday: attributes_for(:matchday).merge(number: nil) }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      describe :active_filter do
        after { get :show, season_id: season.id, id: matchday.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:load_season) }
        specify { controller.should_not_receive(:load_matchday) }
      end
      before { get :show, season_id: season.id, id: matchday.id }
      it { should assign_to :matchday }
    end
    
    describe :in_row do
      describe :active_filter do
        after { get :in_row, season_id: season.id, id: matchday.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
        specify { controller.should_receive(:load_season) }
        specify { controller.should_not_receive(:load_matchday) }
      end
      before do
        get :in_row, season_id: season.id, id: matchday.id
      end
      it { should redirect_to season }
    end
    
  end
  
end
