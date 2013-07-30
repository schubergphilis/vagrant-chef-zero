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
      d.chef_repo_path.must_equal nil
      d.roles.must_equal nil
      d.environments.must_equal nil
      d.nodes.must_equal nil
      d.cookbooks.must_equal nil
      d.data_bags.must_equal nil
    end

  end

  describe "chef_repo_path is the only defined path" do 
    
    it "chef_repo_path should be set" do
      d = DummyClass.new
      d.chef_repo_path = "/foo"
      d.finalize!
      d.chef_repo_path.must_equal "/foo"
    end
    

    it "should use sane defaults and prefix all fixture paths with the chef_repo_path" do
      d = DummyClass.new
      d.stubs(:path_exists?).returns(true)
      d.chef_repo_path = "/foo"
      d.finalize!

      d.roles.must_equal "/foo/roles"
      d.environments.must_equal "/foo/environments"
      d.nodes.must_equal "/foo/nodes"
      d.cookbooks.must_equal "/foo/cookbooks"
      d.data_bags.must_equal "/foo/data_bags"
    end


    it "should keep nil value if sane default path does not exist" do
      d = DummyClass.new
      d.stubs(:path_exists?).returns(true)
      d.stubs(:path_exists?).with("/foo/roles").returns(false)
      d.unstubs(:path_exists?)
      d.chef_repo_path = "/foo"
      d.finalize!

      d.roles.must_equal nil
    end
  end

  describe "chef_repo_path is defined" do 

    describe "specific fixture path is also defined" do

      it "should use sane defaults for all fixture paths except the overloaded path" do
        DummyClass.any_instance.stubs(:path_exists?).returns(true)
        d = DummyClass.new
        d.chef_repo_path = "/foo"
        d.roles = "/bar/roles"
        d.finalize!

        d.roles.must_equal "/bar/roles"
        d.environments.must_equal "/foo/environments"
        d.nodes.must_equal "/foo/nodes"
        d.cookbooks.must_equal "/foo/cookbooks"
        d.data_bags.must_equal "/foo/data_bags"
      end

    end
  end
  


end
