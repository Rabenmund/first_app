#!/bin/env ruby
# encoding: utf-8

class SeasonsController < ApplicationController

  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: []
  skip_filter   :correct_user

  before_filter :load_season, except: [:new, :create, :index]

  def new
    @season = Season.new
  end
  
  def index
    @seasons = Season.paginate(page: params[:page])
  end
  
  def create
    @season = Season.new(params[:season])
    if @season.save
      34.times do |n|
        m = Matchday.new(number: n+1)
        m.date = @season.next_matchday_date
        @season.matchdays << m
        m.save!
      end
      redirect_to @season
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def destroy
    if season.destroy
      flash[:success] = "#{season.name} wurde gelöscht."
    else
      flash[:error] = "#{season.name} konnte nicht gelöscht werden."
      redirect_to season_path(season)
      return
    end
    redirect_to seasons_path
  end
  
  def update
    if @season.update_attributes(params[:season])
      flash[:success] = "Einstellungen geändert."
      render 'show'
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render 'edit'
    end
  end
  
  def show
  end
  
  def calculate
    @season.calculate_all
    redirect_to @season
  end
  
  def load_season
    @season = Season.find(params[:id])
  end
  
end
