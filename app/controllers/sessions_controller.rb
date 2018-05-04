class SessionsController < ApplicationController

	def new

	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
		  if user.activated?	
			log_in(user)
			#userは存在するか、user.authinticateでpasswordが存在するか
			#redirect_to user #object （createの下のuserを見てるから、pathがいらない）
			redirect_back_or user
		  else
		  	flash[:warning] = "Account not activated. Check your email"
		  	redirect_to root_path
		  end

		else
		   flash.now[:danger] = "Invalid Email"
		   render "new"
		end
	end
	
	def destroy
		log_out
		redirect_to root_path
	end

end


