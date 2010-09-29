class Dictionary
  include Mongoid::Document
	
	field :name
  field :hidden, :type => Boolean, :default => false
  referenced_in :domain
end
