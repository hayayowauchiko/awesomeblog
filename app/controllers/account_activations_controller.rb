class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && user.authenticated?(params[:id])
			user.update_attribute(:activated, true)
			user.update_attribute(:activated_at, Time.zone.now)
			log_in(user)
			flash[:success] = "You are activated!"
			redirect_to user
		else
			flash[:notice] = "You must verify your email"
			redirect_to root_path
		end
	end
end
