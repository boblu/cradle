class Group
  include Mongoid::Document
	references_many :privileges
end
