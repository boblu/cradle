# encoding: utf-8
class Domain
  include Mongoid::Document
	include Metainfo
	
	field :label
	field :name
	field :description
	field :hidden, :type => Boolean, :default => false
	
	references_many :dictionaries, :dependent => :delete, :default_order => [:name, :asc]
	
	validates :name, :label, :presence => true, :uniqueness => true
	
	after_save :update_dictionaries_and_features_hidden_state
	
	private
	
	  def update_dictionaries_and_features_hidden_state
	    if hidden
	      Dictionary.collection.update(
	        {'hidden' => false, 'domain_id' => id},
	        {
	          '$set' => {'hidden' => true, 'updated_by' => updated_by, :updated_at => updated_at},
	          '$inc' => { 'version' => 1 }
	        },
	        {:multi => true}
	      )
	      Feature.collection.update(
	        {'hidden' => false, 'dictionary_id' => {'$in' => dictionaries.map(&:id)}},
	        {
	          '$set' => {'hidden' => true, 'updated_by' => updated_by, :updated_at => updated_at},
	          '$inc' => { 'version' => 1 }
	        },
	        {:multi => true}
	      )
	    end
    end
end
