class StaticPagesController < ApplicationController
  
  skip_filter   :authenticate,    only: [:landing, :contact]
  skip_filter   :admin,           only: [:home, :landing, :help, :about, :contact]
  skip_filter   :correct_user,    only: [:home, :landing, :help, :about, :contact]
  
  def home
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.paginate(page: params[:page], per_page: 6)
  end

  def landing
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
