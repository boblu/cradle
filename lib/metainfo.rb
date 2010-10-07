module Metainfo
  extend ActiveSupport::Concern
  
  included do
    include Mongoid::Versioning
  	max_versions 0
  	include Mongoid::Timestamps
  	field :updated_by
  end
  
  module InstanceMethods
    def last_updater_name
      User.criteria.id(updated_by).first.try(:username)
    end
  end
end