# encoding: utf-8
class DictionariesController < ApplicationController
  before_filter :get_parent_domain
  
	def new
	  @dictionary = Dictionary.new
  end
  
  def create
    @dictionary = Dictionary.new(params[:dictionary].update(:domain_id => @domain.id, :updated_by => current_user.id.to_s))
    @dictionaries = (@dictionary.save ? @domain.dictionaries : nil)
  end

  def show
    @dictionary = Dictionary.criteria.id(params[:id]).first
    refresh_content unless @dictionary
  end
  
  def edit
    @dictionary = Dictionary.criteria.id(params[:id]).first
    refresh_content unless @dictionary
  end
  
  def update
    @dictionary = Dictionary.criteria.id(params[:id]).where(:version => params[:dictionary].delete(:version)).first
    if @dictionary
      render (@dictionary.update_attributes(params[:dictionary].update(:updated_by => current_user.id.to_s)) ? :update : :edit)
    else
      (@dictionary = Dictionary.criteria.id(params[:id]).first) ? refresh_self : refresh_content
    end
  end
  
  def destroy
    @dictionary = Dictionary.criteria.id(params[:id]).where(:version => params[:version]).first
    if @dictionary
      @dictionary.destroy and refresh_content(false)
    else
      (@dictionary = Domain.criteria.id(params[:id]).first) ? refresh_self : refresh_content
    end
  end
  
  private
    
    def get_parent_domain
      @domain = Domain.criteria.id(params[:domain_id]).first
    end
    
    # ====================================================
    # = TODO: need to check where to show concurrent msg =
    # ====================================================
    
    def refresh_content(with_msg = true)
      flash[:alert] = t(:concurrent_deleted) if with_msg
      render :refresh_content
    end
    
    def refresh_self
      
    end
end
