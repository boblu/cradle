# encoding: utf-8
class Group
  include Mongoid::Document
	references_many :privileges
end
