class UsersController < ApplicationController
	def initialization
		if User.first.blank?
			@user = User.new
	  else
			redirect_to root_url
	  end
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:notice] = 'User successfully created.'
			redirect_to root_url
		else
			@user.password = @user.password_confirmation = nil
			if User.first.blank?
				render :initialization
      else
      	render :new
      end
    end
  end
end
