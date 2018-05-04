class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: [:destroy,]
	#indexとeditとupdateの時だけlogged_in_userメソッドを呼び出す（ログインしてるかを確認する
	#callback methods must be private
	def new
		@user = User.new

	end

	def index
		@users = User.paginate(page: params[:page])
		current_user
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page], per_page: 15)
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

		if @user.update(user_params)
			flash[:success] = "Finished a Edit!"
			redirect_to user_path(@user.id)
		else
			render "edit"
		end
	end


	def create
		@user = User.new(user_params)

		if @user.save
			UserMailer.account_activation(@user).deliver_now
			flash[:info] = "Please check your email to activate your account"
			redirect_to root_url
			# redirect_to @user user_path
		else
			render "new"
		end

	end


	def destroy
		@user = User.find(params[:id])
		@user.destroy
		redirect_to users_path
	end

    def following
	    @title = "Following"
	    @user  = User.find(params[:id])
	    @users = @user.following.paginate(page: params[:page])
	    render 'show_follow'
	 end

	 def followers
	    @title = "Followers"
	    @user  = User.find(params[:id])
	    @users = @user.followers.paginate(page: params[:page])
	    render 'show_follow'
	 end



	private

	def logged_in_user
		unless logged_in?
		 store_location
		 flash[:danger] = "please log in"
		 redirect_to login_path
		end
	end

	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

	def correct_user
		@user = User.find(params[:id])
		unless @user == current_user
			   redirect_to(root_path)
		end
	end

	def admin_user
		unless current_user.admin?
			redirect_to(root_path) 
		end

	end
end