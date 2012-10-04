#!/bin/env ruby
# encoding: utf-8

class MatchdaysController < ApplicationController

  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: []
  skip_filter   :correct_user
  before_filter :load_season
  before_filter :load_matchday, only: [:edit, :update, :destroy, :in_row, :redate_games]

  def new
    @matchday = @season.matchdays.build(number: @season.next_matchday_number, date: @season.next_matchday_date, arrange_dates: false)
  end
  
  def index
    @matchdays = @season.matchdays
  end

  def create
    @matchday = @season.matchdays.build(params[:matchday])
    if @matchday.save
      redirect_to @season
    else
      render 'new'
    end
  end
  
  def edit
  end
  
#  def destroy
#  end
  
  def update
    @season.put_all_in_fri_row!(@matchday) if params[:matchday][:arrange_dates] == "1"
    if @matchday.update_attributes(params[:matchday])
      flash[:success] = "Einstellungen geändert."
      render :show
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render :edit
    end
  end
  
  def show
    @matchday = Matchday.find(params[:id])
  end
  
  def in_row
    @matchday.season.put_all_in_fri_row!(@matchday)
    redirect_to @season
  end
  
  def redate_games
    @matchday.games.each do |g| 
      puts "#{g.home.name} - #{g.guest.name}: ", g.date
      g.update_attributes(date: @matchday.date)
      puts"new: ", g.date
    end
    redirect_to season_matchday_path(@season, @matchday)
  end
  
  private

  def load_season
    @season = Season.find(params[:season_id])
  end

  def load_matchday
    @matchday = @season.matchdays.find(params[:id])
  end
end
