# encoding: utf-8
class Feature
  include Mongoid::Document
	include Metainfo
	
	SpecialTypes = %w[CharNum]
	NormalTypes = %w[Id Category String Integer Float Boolean Date Time]

	field :fid, :type => Integer
	field :name
	field :type
	field :hidden, :type => Boolean, :default => false
  field :description
  field :default_value
  field :key_field, :type => Boolean
  
  # only for category type
  field :seperator
  
  # only for charnum type
  field :target
  
  referenced_in :dictionary
  
  before_create :set_fid
  before_validation :tidy_up_types
  after_destroy :wrap_out_infor_in_lexicon

  validates :name, :presence => true, :uniqueness => true
  validates_presence_of :target, :if => lambda {|record| record.type == 'CharNum'}
  validates_uniqueness_of :type, :if => lambda {|record| record.type == 'Id'}, :message => 'Id already exists'
  validates_each :key_field do |record, attr, value|
    %w[Id CharNum].each do |kind|
      record.errors.add attr, "can't be set on type #{kind}" if ((record.type == kind) && value)
    end
  end
  validates_each :default_value do |record, attr, value|
    if value.present?
      record.errors.add attr, "is not an integer" if ((record.type == 'Integer') && (value !~ /^\d+$/))
      record.errors.add attr, "is not an float" if ((record.type == 'Float') && (value !~ /^\d+\.\d+$/))
    end
  end
    
  def special_type
    SpecialTypes.include?(type) ? type : nil
  end
  
  def special_type=(value)
    self.type = value
  end
  
  def target_feature
    self.class.criteria.id(target).first
  end
  
  def targeted?
    Feature.where(:target => id.to_s).exists?
  end
  
  private
    
    def set_fid
      self.fid = "feature_#{Preference.first.feature_fid_cache}"
      Preference.first.inc(:feature_fid_cache, 1)
    end
    
    def tidy_up_types
      case type
      when 'CharNum'
        self.seperator = nil
      when 'Category'
        self.target = nil
      else
        self.seperator = nil
        self.target = nil
      end
    end
    
    def wrap_out_infor_in_lexicon
      Lexicon.collection.update(
        {'dictionary_id' => dictionary_id, fid => {'$exists' => true}},
        {'$unset' => {fid => 1}},
        {:multi => true}
      )
    end
end
