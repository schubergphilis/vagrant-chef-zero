require_relative '../spec_helper'

describe "VagrantPlugins::ChefZero::Config" do

  before do
    class DummyClass < VagrantPlugins::ChefZero::Config
    end
  end

  describe "config object is created" do

    it "should set all paths to nil" do 
      d = DummyClass.new
      d.finalize!
      d.chef_repo_path.should eql nil
      d.roles.should eql nil
      d.environments.should eql nil
      d.nodes.should eql nil
      d.cookbooks.should eql nil
      d.data_bags.should eql nil
    end

  end

  describe "chef_repo_path is the only defined path" do 
    
    it "chef_repo_path should be set" do
      d = DummyClass.new
      d.chef_repo_path = "/foo"
      d.finalize!
      d.chef_repo_path.should eql "/foo"
    end
    

    it "should use sane defaults and prefix all fixture paths with the chef_repo_path" do
      DummyClass.any_instance.stub(:path_exists?).and_return(true)
      d = DummyClass.new
      #d.stubs(:path_exists?).returns(true)
      d.chef_repo_path = "/foo"
      d.finalize!

      d.roles.should eql "/foo/roles"
      d.environments.should eql "/foo/environments"
      d.nodes.should eql "/foo/nodes"
      d.cookbooks.should eql "/foo/cookbooks"
      d.data_bags.should eql "/foo/data_bags"
    end


    it "should keep nil value if sane default path does not exist" do
      d = DummyClass.new
      d.stubs(:path_exists?).returns(true)
      d.stubs(:path_exists?).with("/foo/roles").returns(false)
      d.unstubs(:path_exists?)
      d.chef_repo_path = "/foo"
      d.finalize!

      d.roles.should eql nil
    end
  end

  describe "chef_repo_path is defined" do 

    describe "specific fixture path is also defined" do

      it "should use sane defaults for all fixture paths except the overloaded path" do
        DummyClass.any_instance.stub(:path_exists?).and_return(true)
        d = DummyClass.new
        d.chef_repo_path = "/foo"
        d.roles = "/bar/roles"
        d.finalize!

        d.roles.should eql "/bar/roles"
        d.environments.should eql "/foo/environments"
        d.nodes.should eql "/foo/nodes"
        d.cookbooks.should eql "/foo/cookbooks"
        d.data_bags.should eql "/foo/data_bags"
      end

    end
  end
  
end
