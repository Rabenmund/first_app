#!/bin/env ruby
# encoding: utf-8

class SeasonsController < ApplicationController

  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: []
  skip_filter   :correct_user

  def new
    @season = Season.new
  end
  
  def index
    @seasons = Season.paginate(page: params[:page])
  end
  
  def create
    @season = Season.new(params[:season])
    if @season.save
      redirect_to @season
    else
      render 'new'
    end
  end
  
  def edit
    @season = Season.find(params[:id])
  end
  
  def destroy
    season = Season.find(params[:id])
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
    @season = Season.find(params[:id])
    if @season.update_attributes(params[:season])
      flash[:success] = "Einstellungen geändert."
      render 'show'
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render 'edit'
    end
  end
  
  def show
    @season = Season.find(params[:id])
  end
  
end
