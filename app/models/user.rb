# encoding: utf-8
class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :token_authenticatable, :confirmable, :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :timeoutable

	## added by database_authenticatable
	#  field :email
	#  field :encrypted_password
	#  field :password_salt

	## added by rememberable
	#  field :remember_token
	#  field :remember_created_at
	
	## added by trackable
	#  field :sign_in_count
	#  field :current_sign_in_at
	#  field :last_sign_in_at
	#  field :current_sign_in_ip
	#  field :last_sign_in_ip

	field :username
	
	embeds_many :privileges
	
	validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
	
	before_save :set_initial_admin_privilege

	# let user sign in with username or email
	def self.find_for_database_authentication(conditions)
	  value = conditions[authentication_keys.first]
	  value = Regexp.new("^#{Regexp.escape(value.to_s)}$", Regexp::IGNORECASE)
    self.where(:username => value).first || self.where(:email => value).first
	end

  private
  
	  def set_initial_admin_privilege
	  	if self.class.first.blank?
	  		self.privileges << Privilege.new(:group_id => 0, :role => :admin)
	  	end
	  	return
	  end
end
