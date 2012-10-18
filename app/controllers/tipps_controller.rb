#!/bin/env ruby
# encoding: utf-8

class TippsController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:create, :new, :index, :show, :update, :edit, :save_tipps]
  skip_filter   :correct_user,    only: []
  before_filter :load_season
  before_filter :load_matchday
  before_filter :load_tipp,       only: [:show, :edit, :update]

  def new
  end
  
#  # User: Tipps Anzeige: Season->Matchdays->Tipps für nicht "finished" seasons / "started" matchdays
#  # before filter hier benötigt für finished seasons, started matchdays
#  # nur admin darf Tipps sehen/ändern für andere Seasons oder Matchdays
  
  def index_user
    # not finished season -> param or preselected
    # all md for season -> param or preselected
    # all tipps for md, -> editing not possible for date in passed(before filter)
    # @games = @matchday.games.active
  end
  
  def save_tipps
    i=0
    params[:game_count].to_i.times do
      i += 1
      game = @matchday.games.find(params["game_id-#{i}".to_sym])
      tipp = game.tipps.find_by_user_id(@user.id)
      if tipp
        tipp.home_goals = params["home-#{i}"].to_i
        tipp.guest_goals = params["guest-#{i}"].to_i
      else
        tipp = @user.tipps.new(game_id: game.id, home_goals: params["home-#{i}"].to_i, guest_goals: params["guest-#{i}"].to_i )
      end
      if tipp.save
        flash[:success] = "Spieltag gespeichert!"
      else
        flash[:error] = "Spieltag konnte nicht gespeichert werden."
      end
    end
    render 'index'
  end
  
  def create
  end
  
  def edit
  end
  
#  def destroy
#  end
  
  def update
  end
  
  def show
  end
  
  private
  
  def load_tipp
    if params[:id]
      @tipp = Tipp.find(params[:id])
      puts "---> @tipp", @tipp
    else
      puts "----> md.tipps:", @matchday.tipps.inspect
      @tipp = @matchday.tipps.active.first unless @matchday.tipps.active.empty?
    end
  end
  
  def load_matchday
    if params[:matchday_id]
      @matchday = @season.matchdays.find(params[:matchday_id])
    else
      @matchday = @season.matchdays.active.first unless @season.matchdays.empty?
    end
  end
  
  def load_season
    # preselected or selected (in param)
    if params[:season_id]
      @season = @user.seasons.find(params[:season_id])
    else
      @season = Season.active.first unless Season.active.empty?
    end
  end

end
