class SessionsController < ApplicationController
  
  skip_filter   :authenticate,    only: [:new, :create]
  skip_filter   :admin,           only: [:new, :create, :destroy]
  skip_filter   :correct_user,    only: [:new, :create]
  
  def new
  end

  def create
    user = User.find_by_email(params[:session][:auth]) || User.find_by_nickname(params[:session][:auth])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or home_path
    else
      flash.now[:error] = 'Anmeldung nicht korrekt.'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to landing_path
  end
  
end