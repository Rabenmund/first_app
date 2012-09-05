#!/bin/env ruby
# encoding: utf-8

class TeamsController < ApplicationController

  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: []
  skip_filter   :correct_user

  def new
    @team = Team.new
  end
  
  def index
    @teams = Team.paginate(page: params[:page])
  end
  
  def create
    @team = Team.new(params[:team])
    if @team.save
      redirect_to @team
    else
      render 'new'
    end
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def destroy
    team = Team.find(params[:id])
    if team.destroy
      flash[:success] = "#{team.name} wurde gelöscht."
    else
      flash[:error] = "#{team.name} konnte nicht gelöscht werden."
      redirect_to team_path(team)
      return
    end
    redirect_to teams_path
  end
  
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:success] = "Einstellungen geändert."
      render 'show'
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render 'edit'
    end
  end
  
  def show
    @team = Team.find(params[:id])
  end
  
end
