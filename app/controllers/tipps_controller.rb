#!/bin/env ruby
# encoding: utf-8

class TippsController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:create, :new, :index, :show, :update, :edit]
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
    @tipps = @matchday.tipps
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
    else
      @tipp = @matchday.active.first unless @matchday.active.empty?
    end
  end
  
  def load_matchday
    if params[:matchday_id]
      @matchday = Matchday.find(params[:matchday_id])
    else
      @matchday = @season.matchdays.active.first unless @season.matchdays.empty?
    end
  end
  
  def load_season
    # preselected or selected (in param)
    if params[:season]
      @season = Season.find(params[:season_id])
    else
      @season = Season.active.first unless Season.active.empty?
    end
  end

end
