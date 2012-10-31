#!/bin/env ruby
# encoding: utf-8

class TippsController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:index, :save_tipps]
  skip_filter   :correct_user,    only: []
  before_filter :load_season
  before_filter :load_matchday
  before_filter :load_tipp,       only: []

#  # User: Tipps Anzeige: Season->Matchdays->Tipps für nicht "finished" seasons / "started" matchdays
#  # before filter hier benötigt für finished seasons, started matchdays
#  # nur admin darf Tipps sehen/ändern für andere Seasons oder Matchdays
  
  def index
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
  
  def select_user
    redirect_to user_season_matchday_tipps_index_path(params[:user], @season, @matchday)
  end
  
  private
  
  def load_tipp
    if params[:id]
      @tipp = Tipp.find(params[:id])
    else
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
    if params[:season_id]
      @season = @user.seasons.active.find(params[:season_id])
    else
      if current_user.is_admin?
        @season = Season.active.first unless Season.active.empty?
      else
        redirect_to home_path
      end
    end
  end

end
