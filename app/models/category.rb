# encoding: utf-8
class Category
  include Mongoid::Document
	include Metainfo
	
	field :name

end
