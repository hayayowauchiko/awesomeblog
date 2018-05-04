class StaticPagesController < ApplicationController
  def home
  	 if logged_in?

  	 	@feed_items = current_user.feed.paginate(page: params[:page], per_page: 15)
  		# @message = "Someone is logged in"
  		# @user = current_user

		# @user = User.find(params[:id])
		# @microposts = @user.microposts.paginate(page: params[:page], per_page: 15)
   	    @micropost = current_user.microposts.build
  	 end
  end

  def help
  end
end
