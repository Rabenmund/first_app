#!/bin/env ruby
# encoding: utf-8

class UsersController < ApplicationController

  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:index, :edit, :update, :show ]
  skip_filter   :correct_user,    only: [:index, :show, :new, :create, :destroy, :deactivate, :activate]
  before_filter :check_admin,     only: [:activate]

  def new
    @user = User.new
    @user.deactivated = true
  end
  
  def index
    @users = User.paginate(page: params[:page])
    @activated_users = User.where(deactivated: false)
    @deactivated_users = User.where(deactivated: true)
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = "#{user.name} wurde gelöscht."
    else
      flash[:error] = "#{user.name} konnte nicht gelöscht werden."
      redirect_to user_path(user)
      return
    end
    redirect_to users_path
  end
  
  def update
    @user = User.find(params[:id])
#    params[:user][:password_confirmation] = params[:user][:password]
    if @user.update_attributes(params[:user])
      flash[:success] = "Einstellungen geändert."
      sign_in @user
      render 'show'
    else
      flash[:error] = "Einstellungen konnten nicht geändert werden."
      render 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def deactivate
    @user = User.find(params[:id])
    if @user.deactivate!
      flash[:success] = "#{@user.name} deaktiviert"
    else
      flash[:error] = "#{@user.name} konnte nicht deaktiviert werden"
    end
    redirect_to users_path
  end
  
  def activate
    @user = User.find(params[:id])
    if @user.activate!
      flash[:success] = "#{@user.name} aktiviert"
    else
      flash[:error] = "#{@user.name} konnte nicht aktiviert werden"
    end
    redirect_to users_path
  end
  
  private
  
  def check_admin
    @user = User.find(params[:id])
    if @user.is_admin?
      flash[:error] = "#{@user.name} ist ein Admin und kann nicht aktiviert werden."
      redirect_to users_path
    end
  end
      
end
