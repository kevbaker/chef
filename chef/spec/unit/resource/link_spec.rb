#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Chef::Resource::Link do

  before(:each) do
    @resource = Chef::Resource::Link.new("fakey_fakerton")
  end  

  it "should create a new Chef::Resource::Link" do
    @resource.should be_a_kind_of(Chef::Resource)
    @resource.should be_a_kind_of(Chef::Resource::Link)
  end
  
  it "should have a name" do
    @resource.name.should eql("fakey_fakerton")
  end
  
  it "should have a default action of 'create'" do
    @resource.action.should eql(:create)
  end
  
  { :create => false, :delete => false, :blues => true }.each do |action,bad_value|
    it "should #{bad_value ? 'not' : ''} accept #{action.to_s}" do
      if bad_value
        lambda { @resource.action action }.should raise_error(ArgumentError)
      else
        lambda { @resource.action action }.should_not raise_error(ArgumentError)
      end
    end
  end
    
  it "should use the object name as the target_file by default" do
    @resource.target_file.should eql("fakey_fakerton")
  end
  
  it "should accept a string as the link source via 'to'" do
    lambda { @resource.to "/tmp" }.should_not raise_error(ArgumentError)
  end
  
  it "should not accept a Hash for the link source via 'to'" do
    lambda { @resource.to Hash.new }.should raise_error(ArgumentError)
  end
  
  it "should allow you to set a link source via 'to'" do
    @resource.to "/tmp/foo"
    @resource.to.should eql("/tmp/foo")
  end
  
  it "should allow you to specify the link type" do
    @resource.link_type "symbolic"
    @resource.link_type.should eql(:symbolic)
  end
  
  it "should default to a symbolic link" do
    @resource.link_type.should eql(:symbolic)
  end
  
  it "should accept a hard link_type" do
    @resource.link_type :hard
    @resource.link_type.should eql(:hard)
  end
  
  it "should reject any other link_type but :hard and :symbolic" do
    lambda { @resource.link_type "x-men" }.should raise_error(ArgumentError)
  end
  
  it "should accept a group name or id for group" do
    lambda { @resource.group "root" }.should_not raise_error(ArgumentError)
    lambda { @resource.group 123 }.should_not raise_error(ArgumentError)
    lambda { @resource.group "root*goo" }.should raise_error(ArgumentError)
  end

  it "should accept a user name or id for owner" do
    lambda { @resource.owner "root" }.should_not raise_error(ArgumentError)
    lambda { @resource.owner 123 }.should_not raise_error(ArgumentError)
    lambda { @resource.owner "root*goo" }.should raise_error(ArgumentError)
  end

end
