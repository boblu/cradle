class Domain
  include Mongoid::Document
	
	field :label
	field :name
	field :description
  field :hidden, :type => Boolean, :default => false
  references_many :dictionaries, :dependent => :destroy

	validates_presence_of :label, :name
	validates_uniqueness_of :label, :name
end
