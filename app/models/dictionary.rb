# encoding: utf-8
class Dictionary
  include Mongoid::Document
	include Metainfo
	
	field :name
	field :label
  field :hidden, :type => Boolean, :default => false
  field :description
  
	referenced_in :domain
	references_many :features, :dependent => :delete, :default_order => :key_field.desc
	
	validates :name, :label, :presence => true, :uniqueness => true
	
	after_save :update_features_hidden_state
	after_destroy :wrap_out_inlcuded_lexicon
	
	private
	
	  def update_features_hidden_state
	    if hidden
	      Feature.collection.update(
	        {'hidden' => false, 'dictionary_id' => id},
	        {
	          '$set' => {'hidden' => true, 'updated_by' => updated_by, :updated_at => updated_at},
	          '$inc' => { 'version' => 1 }
	        },
	        {:multi => true}
	      )
	    end
    end
    
    def wrap_out_inlcuded_lexicon
      Lexicon.collection.remove({'dictionary_id' => id.to_s}, {:multi => true})
    end
end
