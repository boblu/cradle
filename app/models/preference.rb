class Preference
  include Mongoid::Document
	include Metainfo
	
	field :name, :default => 'Cradle'
	field :feature_fid_cache, :type => Integer, :default => 1
end