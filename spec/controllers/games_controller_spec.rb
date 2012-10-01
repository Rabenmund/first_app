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
      before { get :new, season_id: season.id, matchday_id: matchday.id }
      it { should assign_to :game }
    end
    
    describe :index do
      before { get :index, season_id: season.id, matchday_id: matchday.id }
      it { should assign_to :games }
    end
    
    describe :create do
      describe :valid do
        before do
          Game.any_instance.stub(:home_associated_to_season).and_return(true)
          Game.any_instance.stub(:guest_associated_to_season).and_return(true)
          Game.any_instance.stub(:date_in_seasons_range).and_return(true)
          post :create, season_id: season.id, matchday_id: matchday.id, game: attributes_for(:game)
        end
        it { should assign_to :game }
        it { should set_the_flash.to "Spiel wurde erstellt." }
        specify { response.should redirect_to season_matchday_game_path(season, matchday, Game.last ) }
        it { expect { post :create, season_id: season.id, matchday_id: matchday.id, game: attributes_for(:game) }.to change(Game, :count).by(1)}
      end
      describe :invalid do
        before { post :create, season_id: season.id, matchday_id: matchday.id, game: {} }
        it { should render_template "new" }
        it { should set_the_flash.to "Neues Spiel konnte nicht erstellt werden." }
        it { expect { post :create, season_id: season.id, matchday_id: matchday.id, game: {} }.to change(Game, :count).by(0)}
      end
    end
    
    describe :edit do
      before { get :edit, season_id: season.id, matchday_id: matchday.id, id: game.id }
      it { should assign_to :game }
    end
    
    describe :destroy do
      before { @game = create :game, matchday: matchday }
      describe :valid do
        before { delete :destroy, season_id: season.id, matchday_id: matchday.id, id: @game.id  }
        it { should set_the_flash.to "#{@game.id} wurde gelöscht." }
        specify { response.should redirect_to season_matchday_games_path }
        it { expect { @game2 = create :game, matchday: matchday; delete :destroy, season_id: season.id, matchday_id: matchday.id, id: @game2.id  }.to change(Game, :count).by(0)}
      end
      describe :invalid do
        before do
          Game.any_instance.stub(:destroy).and_return(false)
          delete :destroy, season_id: season.id, matchday_id: matchday.id, id: @game.id 
        end
        it { should set_the_flash.to "#{@game.id} konnte nicht gelöscht werden." }
        specify { response.should redirect_to season_matchday_game_path(@game) }
        it { expect { delete :destroy, season_id: season.id, matchday_id: matchday.id, id: @game.id  }.to change(Game, :count).by(0)}
      end
    end
    
    describe :update do
      before { @game = create :game, matchday: matchday }
      describe :valid do
        before { put :update, season_id: season.id, matchday_id: matchday.id, id: @game.id, game: {date: DateTime.now}  }
        it { should set_the_flash.to "Einstellungen geändert." }
        specify { response.should render_template "show"}
      end
      describe :invalid do
        before { put :update, season_id: season.id, matchday_id: matchday.id, id: @game.id, game: {date: nil} }
        it { should set_the_flash.to "Einstellungen konnten nicht geändert werden." }
        specify { response.should render_template "edit"}
      end
    end
    
    describe :show do
      before { get :show, season_id: season.id, matchday_id: matchday.id, id: game.id }
      it { should assign_to :game }
    end
  end
  
end
