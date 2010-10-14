# encoding: utf-8
class DictionariesController < ApplicationController
  before_filter :get_parent_domain
  
	def new
	  @dictionary = Dictionary.new(:hidden => @domain.hidden)
  end
  
  def create
    @dictionary = @domain.dictionaries.build(params[:dictionary].update(:updated_by => current_user.username))
    @dictionaries = (@dictionary.save ? @domain.dictionaries.to_a : nil)
  end

  def show
    @dictionary = Dictionary.criteria.id(params[:id]).first
    refresh_section unless @dictionary
  end
  
  def edit
    @dictionary = Dictionary.criteria.id(params[:id]).first
    refresh_section unless @dictionary
  end
  
  def update
    @dictionary = Dictionary.criteria.id(params[:id]).where(:version => params[:dictionary].delete(:version)).first
    if @dictionary
      render (@dictionary.update_attributes(params[:dictionary].update(:updated_by => current_user.username)) ? :show : :edit)
    else
      (@dictionary = Dictionary.criteria.id(params[:id]).first) ? refresh_self : refresh_section
    end
  end
  
  def destroy
    # ===============================
    # = TODO: validate for deletion =
    # ===============================
    
    @dictionary = Dictionary.criteria.id(params[:id]).where(:version => params[:version]).first
    if @dictionary
      @dictionary.destroy and refresh_section(false)
    else
      (@dictionary = Dictionary.criteria.id(params[:id]).first) ? refresh_self : refresh_section
    end
  end
  
  private
    
    def get_parent_domain
      @domain = Domain.criteria.id(params[:domain_id]).first
      unless @domain
        flash[:alert] = t(:concurrent_deleted)
        @domains = Domain.order_by([:name, :asc]).all.to_a
        @tab = '1'
        @domain = @domains[0] || Domain.new
        render 'domains/refresh_tab'
      end
    end
    
    def refresh_section(with_msg = true)
      flash[:alert] = t(:concurrent_deleted) if with_msg
      render :refresh_section
    end
    
    def refresh_self
      flash[:alert] = t(:concurrent_updated)
      render :show      
    end
end
