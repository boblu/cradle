# encoding: utf-8
class DomainsController < ApplicationController
  def index
    @domains = Domain.all
    @domain = @domains[0] || Domain.new
    render :partial => "index"
  end

  def new
    @domain = Domain.new
  end
  
  def create
    @domain = Domain.new(params[:domain].update(:updated_by => current_user.id.to_s))
    @domains = (@domain.save ? Domain.all : nil)
  end
  
  def show
    @domain = Domain.criteria.id(params[:id]).first
    refresh_tab unless @domain
  end
  
  def edit
    @domain = Domain.criteria.id(params[:id]).first
    refresh_tab unless @domain
  end
  
  def update
    @domain = Domain.criteria.id(params[:id]).where(:version => params[:domain].delete(:version)).first
    if @domain
      render (@domain.update_attributes(params[:domain].update(:updated_by => current_user.id.to_s)) ? :update : :edit)
    else
      (@domain = Domain.criteria.id(params[:id]).first) ? refresh_content : refresh_tab
    end
  end
  
  def destroy
    @domain = Domain.criteria.id(params[:id]).where(:version => params[:version]).first
    if @domain
      @domain.destroy and refresh_tab(false)
    else
      (@domain = Domain.criteria.id(params[:id]).first) ? refresh_content : refresh_tab
    end
  end
  
  private
    def refresh_tab(with_msg = true)
      flash[:alert] = t(:concurrent_deleted) if with_msg
      @domains = Domain.all
      @domain = @domains[0] || Domain.new
      render :refresh_tab
    end
    
    def refresh_content
      flash[:alert] = t(:concurrent_updated)
      render :show
    end
end
