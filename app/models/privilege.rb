class Privilege
	include Mongoid::Document
	
	field :role_level, :type => Integer
	referenced_in :group

	embedded_in :user, :inverse_of => :privileges
	
	Roles = {
		:admin			=> 100,
		:moderator	=> 90,
		:annotator	=> 80,
		:subscriber => 60
	}
	
	def role=(temp_role)
		self.role_level = Roles[temp_role.intern]
	end
	
	def role
		Roles.key(role_level)
	end
end