class FeaturesController < ApplicationController
  before_filter :get_parent_domain_and_dic
  
  def new
    @feature = Feature.new(:hidden => @dictionary.hidden)
  end
  
  def create
    @feature = @dictionary.features.build(params[:feature].update(:updated_by => current_user.username))
    @features = (@feature.save ? @dictionary.features.to_a : nil)
  end

  def show
    @feature = Feature.criteria.id(params[:id]).first
    refresh_section unless @feature
  end

  def edit
    @feature = Feature.criteria.id(params[:id]).first
    refresh_section unless @feature
  end
  
  def update
    @feature = Feature.criteria.id(params[:id]).where(:version => params[:feature].delete(:version)).first
    if @feature
      render (@feature.update_attributes(params[:feature].update(:updated_by => current_user.username)) ? :show : :edit)
    else
      (@feature = Feature.criteria.id(params[:id]).first) ? refresh_self : refresh_section
    end
  end
  
  def destroy
    @feature = Feature.criteria.id(params[:id]).where(:version => params[:version]).first
    if @feature
      if @feature.targeted?
        flash[:alert] = "Delete failed. Feature #{@feature.name} is the target of other CharNum feature."
        render :refresh_section
      else
        @feature.destroy and refresh_section(false)
      end
    else
      (@feature = Feature.criteria.id(params[:id]).first) ? refresh_self : refresh_section
    end
  end

  private
    
    def get_parent_domain_and_dic
      @domain = Domain.criteria.id(params[:domain_id]).first
      unless @domain
        flash[:alert] = t(:concurrent_deleted)
        @domains = Domain.order_by([:name, :asc]).all.to_a
        @tab = '2'
        unless @domains.size == 0
          @domain = @domains[0]
          @dictionaries = @domain.dictionaries.to_a
          unless @dictionaries.size == 0
            @dictionary = @dictionaries[0]
          end
        end
        render 'domains/refresh_tab'
      end
      @dictionary = Dictionary.criteria.id(params[:dictionary_id]).first
      unless @dictionary
        flash[:alert] = t(:concurrent_deleted)
        @dictionaries = @domain.dictionaries.to_a
        @tab = '2'
        unless @dictionaries.size == 0
          @dictionary = @dictionaries[0]
        end
        render 'domains/show'
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
