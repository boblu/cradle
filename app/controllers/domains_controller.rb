# encoding: utf-8
class DomainsController < ApplicationController
  def index
    @tab = params[:tab]
    get_necessary_objects
    render :partial => "index"
  end

  def new
    @domain = Domain.new
  end
  
  def create
    @domain = Domain.new(params[:domain].update(:updated_by => current_user.username))
    @domains = (@domain.save ? Domain.order_by([:name, :asc]).all.to_a : nil)
    @tab = '1'
  end
  
  def show
    @domain = Domain.criteria.id(params[:id]).first
    if @domain
      if ((@tab = params[:tab]) == '2')
        @dictionaries = @domain.dictionaries.to_a
        unless @dictionaries.size == 0
          @dictionary = @dictionaries[0]
        end
      end
    else
      refresh_tab(:tab => params[:tab])
    end
  end
  
  def edit
    @domain = Domain.criteria.id(params[:id]).first
    refresh_tab unless @domain
  end
  
  def update
    @domain = Domain.criteria.id(params[:id]).where(:version => params[:domain].delete(:version)).first
    if @domain
      render (@domain.update_attributes(params[:domain].update(:updated_by => current_user.username)) ? :show : :edit)
    else
      (@domain = Domain.criteria.id(params[:id]).first) ? refresh_content : refresh_tab
    end
  end
  
  def destroy
    @domain = Domain.criteria.id(params[:id]).where(:version => params[:version]).first
    if @domain
      @domain.destroy and refresh_tab(:with_msg => false)
    else
      (@domain = Domain.criteria.id(params[:id]).first) ? refresh_content : refresh_tab
    end
  end
  
  private

    def refresh_tab(options = {})
      options[:tab] ||= '1'
      @tab = options[:tab]
      options[:with_msg] = true unless (options[:with_msg] == false)
      flash[:alert] = t(:concurrent_deleted) if options[:with_msg]
      get_necessary_objects
      render :refresh_tab
    end
  
    def refresh_content
      flash[:alert] = t(:concurrent_updated)
      render :show
    end
    
    def get_necessary_objects
      @domains = Domain.order_by([:name, :asc]).all.to_a
      case @tab
      when '1'
        @domain = @domains[0] || Domain.new
      when '2'
        unless @domains.size == 0
          @domain = @domains[0]
          @dictionaries = @domain.dictionaries.to_a
          unless @dictionaries.size == 0
            @dictionary = @dictionaries[0]
          end
        end
      end
    end
end
