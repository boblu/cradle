# encoding: utf-8
class UsersController < ApplicationController
	def initialization
		if User.first.blank?
			@user = User.new
			Preference.create if Preference.first.blank?
	  else
			redirect_to root_url
	  end
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			redirect_to login_url, :flash => { :notice => 'Administrator successfully created. Please login to continue.' }
		else
			@user.clean_up_passwords
			render (User.first.blank? ? :initialization : :new)
    end
  end
end
