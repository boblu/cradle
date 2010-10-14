require 'spec_helper'

describe Domain do
  before do
    @domain = Domain.create(:name => 'Chinese', :label => 'cn')
    @dic1 = @domain.dictionaries.create(:name => 'chinese dic1', :label => 'cn-dic1')
    @dic2 = @domain.dictionaries.create(:name => 'chinese dic2', :label => 'cn-dic2')
  end

  after do
    Domain.delete_all
    Dictionary.delete_all
  end
  
  it "should hide all below dictionaries after changing self to hidden" do
    @domain.hidden.should be_false
    @dic1.hidden.should be_false
    @dic2.hidden.should be_false
    @domain.update_attributes(:hidden => true)
    @domain.reload.hidden.should be_true
    @dic1.reload.hidden.should be_true
    @dic2.reload.hidden.should be_true
  end
  
  it 'should delete all below dictionaries when destroyed' do
    @domain.destroy
    Domain.all.size.should == 0
    Dictionary.all.size.should == 0
  end
end