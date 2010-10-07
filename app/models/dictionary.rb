# encoding: utf-8
class Dictionary
  include Mongoid::Document
	include Metainfo
	
	field :name
	field :label
  field :hidden, :type => Boolean, :default => false
  field :description
  
	referenced_in :domain
	
	validates :name, :presence => true, :uniqueness => true
end
