#!/bin/env ruby
# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :authenticate
  before_filter :admin
  before_filter :correct_user
  
  private
  
  def authenticate
    if !signed_in? # || current_session.expired? # tbd
      flash[:error] = 'Bitte melde dich an !'
      redirect_to new_session_path
    elsif (current_user.deactivated? && !current_user.is_admin?)
      flash[:error] = 'Bitte melde dich mit einem gültigen Benutzer an!'
      redirect_to new_session_path
    end
  end
  
  def admin
    redirect_to(root_path) unless current_user.is_admin?
  end
  
  def correct_user
    @user = params[:id] ? User.find(params[:id]) : User.find(params[:user_id])
    redirect_to(root_path) unless current_user?(@user) || current_user.is_admin?
  end
  
end
