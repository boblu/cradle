source 'http://rubygems.org'

gem 'rails', '3.0.0'

gem 'ruby-debug19', :require => 'ruby-debug'

# mongoid
gem "mongoid", :git => "git://github.com/mongoid/mongoid.git"
gem 'bson', '1.0.9'
gem 'bson_ext', '1.0.9'

## devise
gem 'devise'

## required by devise when using mongoid orm
gem 'mongo_ext'
gem 'bcrypt-ruby'

gem 'cancan'

group :development do
	gem 'capistrano'
	gem 'map_by_method'
	gem 'wirble'
	gem "rspec-rails", ">= 2.0.0.rc"
end

group :test do
	gem "rspec-rails", ">= 2.0.0.rc"
	gem 'autotest'
end