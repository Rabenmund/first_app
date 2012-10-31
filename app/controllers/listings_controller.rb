#!/bin/env ruby
# encoding: utf-8

class ListingsController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:overview, :tipplist]
  skip_filter   :correct_user
  before_filter :load_season
  before_filter :load_matchday

  def overview
  end
  
  def tipplist
  end
  
  private
  
  def load_matchday
    if params[:matchday_id]
      @matchday = @season.matchdays.find(params[:matchday_id])
    else
      @matchday = @season.matchdays.active.first unless @season.matchdays.empty?
    end
  end
  
  def load_season
    # preselected or selected (in param)
    if current_user.is_admin?
      @season = Season.active.first unless Season.active.empty?
    else
      if params[:season_id]
        @season = current_user.seasons.find(params[:season_id])
      else
        redirect_to home_path
      end
    end
  end

end