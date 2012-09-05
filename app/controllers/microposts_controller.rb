#!/bin/env ruby
# encoding: utf-8
class MicropostsController < ApplicationController
  
  skip_filter   :authenticate,    only: []
  skip_filter   :admin,           only: [:create]
  skip_filter   :correct_user,    only: [:create, :destroy]
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Kurznachricht erstellt."
      redirect_to root_path
    else
      flash[:error] = "Kurznachricht konnte nicht erstellt werden."
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    if @micropost.destroy
      flash[:success] = "Kurznachricht gelöscht."
    else
      flash[:error] = "Kurznachricht konnte nicht gelöscht werden."
    end
    redirect_to root_path
  end
end