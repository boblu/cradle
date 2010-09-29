class DomainsController < ApplicationController
	def index
		@domains = Domain.all
		@domain = @domains[0] || Domain.new
    respond_to do |format|
      format.html {render :partial => "index"}
      format.xml
    end
	end

	def new
		@domain = Domain.new
	end

	def create
		@domain = Domain.new(params[:domain])
		if @domain.save
			@domains = Domain.all
		else
			@domains = nil
		end
	end
	
	def show
		@domain = Domain.find(params[:id])
	end
	
	def edit
		@domain = Domain.find(params[:id])
	end
	
	def update
		@domain = Domain.find(params[:id])
		if @domain.update_attributes(params[:domain])
			render :show
		else
			render :edit
		end
	end
	
	def destroy
		
	end
end
