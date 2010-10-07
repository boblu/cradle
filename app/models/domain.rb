# encoding: utf-8
class Domain
  include Mongoid::Document
	include Metainfo
	
	field :label
	field :name
	field :description
	field :hidden, :type => Boolean, :default => false
	
	references_many :dictionaries, :dependent => :delete
	
	validates :name, :label, :presence => true, :uniqueness => true
	
	after_save :update_dictionaries_hidden_state
	
	private
	
	  def update_dictionaries_hidden_state
	    dictionaries.each do |dic|
	      dic.update_attributes(:updated_at => updated_at, :updated_by => updated_by)
      end
    end
end
