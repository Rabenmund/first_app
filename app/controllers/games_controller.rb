#!/bin/env ruby
# encoding: utf-8

class GamesController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: []
  skip_filter   :correct_user
  before_filter :load_season
  before_filter :load_matchday
  before_filter :load_game, only: [:show, :edit, :update, :destroy]

  def new
    @game = Game.new
  end
  
  def index
    @games = @matchday.games.paginate(page: params[:page])
  end
  
  def create
    @game = @matchday.games.new(params[:game])
    if @game.save
      flash[:success] = "Spiel wurde erstellt."
      redirect_to season_matchday_path(@season, @matchday)
    else
      flash[:error] = "Neues Spiel konnte nicht erstellt werden."
      render 'new'
    end
  end
  
  def edit
  end
  
  def destroy
    game = Game.find(params[:id])
    if game.destroy
      flash[:success] = "#{game.id} wurde gelöscht."
    else
      flash[:error] = "#{game.id} konnte nicht gelöscht werden."
      redirect_to season_matchday_game_path(game)
      return
    end
    redirect_to season_matchday_path(params[:season_id], params[:matchday_id])
  end
  
  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:success] = "Einstellungen geändert."
      redirect_to season_matchday_path(@season, @matchday)
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render 'edit'
    end
  end
  
  def show
  end
  
  private

  def load_season
    @season = Season.find(params[:season_id])
  end

  def load_matchday
    @matchday = @season.matchdays.find(params[:matchday_id])
  end
  
  def load_game
    @game = @matchday.games.find(params[:id])
  end
  
end
