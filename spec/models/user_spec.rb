require 'spec_helper'

describe User do
  after do
    User.delete_all
  end
  
  context 'when it is a new record' do
    let(:user) {User.new(:email => 'boblu@test.com', :password => 'abcdefg', :password_confirmation => 'abcdefg')}

    it 'should validate username for presence and uniqueness' do
      user.should_not be_valid
      user.username = 'boblu'
      user.should be_valid
      User.create(:username => 'rui', :email => 'rui@test.com', :password => 'hijklmn', :password_confirmation => 'hijklmn')
      user.username = 'boblu'
      user.should be_valid
      user.username = 'rui'
      user.should_not be_valid
      user.username = 'Rui'
      user.should_not be_valid
      user.username = '...'
      user.should be_valid
    end    
  end
  
  context 'when it is not new record' do
    let(:user) {User.create(:username => 'boblu', :email => 'boblu@test.com', :password => 'abcdefg', :password_confirmation => 'abcdefg')}
    let(:another_user) {User.create(:username => 'rui', :email => 'rui@test.com', :password => 'hijklmn', :password_confirmation => 'hijklmn')}

    it 'should validate username for presence and uniqueness' do
      user and another_user
      user.should be_valid
      user.username = nil
      user.should_not be_valid
      user.username = 'rui'
      user.should_not be_valid
      user.username = 'RUI'
      user.should_not be_valid
      user.username = 'boblu'
      user.should be_valid
      user.username = 'BoBlU'
      user.should be_valid
      user.username = '...'
      user.should be_valid
    end
  end
  
  context 'when initialating' do
    it 'should set initial admin privilege' do
      User.count.should == 0
      user = User.new(:username => 'boblu', :email => 'boblu@test.com', :password => 'abcdefg', :password_confirmation => 'abcdefg')
      user.save.should be_true
      user.privileges.size.should == 1
      user.privileges.first.group_id.should == 0
      user.privileges.first.role.should == :admin
    end
  end
  
  context 'when authenticating' do
    let(:user) {User.create(:username => 'boblu', :email => 'boblu@test.com', :password => 'abcdefg', :password_confirmation => 'abcdefg')}
    
    it 'should use username or email' do
      user
      User.find_for_database_authentication({:username => 'BoBlU'}).should == user
      User.find_for_database_authentication({:username => "BoBlU@test.com"}).should == user
    end
  end
end
