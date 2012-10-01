#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe GamesController do
  
  let(:game) { create :game }
  let(:matchday) { game.matchday }
  let(:season) { matchday.season }
  
  subject { controller }
  
  describe :action do
    
    before do
      controller.stub(:authenticate).and_return(true)
      controller.stub(:admin).and_return(true)
      controller.stub(:correct_user).and_return(true)
    end
    
    describe :new do
      describe :active_filter do
        after { get :new, season_id: season.id, matchday_id: matchday.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :new }
      it { should assign_to :game }
    end
    
    describe :index do
      describe :active_filter do
        after { get :index }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :index }
      it { should assign_to :games }
    end
    
    describe :create do
      describe :active_filter do
        after { post :create, season: attributes_for(:season) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { post :create, game: attributes_for(:game) }
        it { should assign_to :game }
        specify { response.should redirect_to Game.last }
        it { expect { post :create, game: attributes_for(:game) }.to change(Game, :count).by(1)}
      end
      describe :invalid do
        before { post :create, game: {} }
        it { should render_template "new" }
        it { expect { post :create, game: {} }.to change(Game, :count).by(0)}
      end
    end
    
    describe :edit do
      describe :active_filter do
        after { get :edit, id: season.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :edit, id: game.id }
      it { should assign_to :game }
    end
    
    describe :destroy do
      before { @game = create :game }
      describe :active_filter do
        after { delete :destroy, id: @game.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { delete :destroy, id: @game.id  }
        it { should set_the_flash.to "#{@game.name} wurde gelöscht." }
        specify { response.should redirect_to season_matchday_games_path }
        it { expect { @game = create :game; delete :destroy, id: @game.id  }.to change(Game, :count).by(0)}
      end
      describe :invalid do
        before do
          Game.any_instance.stub(:destroy).and_return(false)
          delete :destroy, id: @game.id 
        end
        it { should set_the_flash.to "#{@game.name} konnte nicht gelöscht werden." }
        specify { response.should redirect_to season_matchday_game_path(@game) }
        it { expect { delete :destroy, id: @game.id  }.to change(Game, :count).by(0)}
      end
    end
    
    describe :update do
      before { @game = create :game }
      describe :active_filter do
        after { put :update, id: @game.id, game: attributes_for(:game) }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      describe :valid do
        before { put :update, id: @game.id, game: attributes_for(:game).merge(name: "Other Name")  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, id: @game.id, game: attributes_for(:game).merge(name: nil) }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      describe :active_filter do
        after { get :show, id: game.id }
        specify { controller.should_receive(:authenticate) }
        specify { controller.should_receive(:admin) }
        specify { controller.should_not_receive(:correct_user) }
      end
      before { get :show, id: game.id }
      it { should assign_to :game }
    end
  end
  
end
