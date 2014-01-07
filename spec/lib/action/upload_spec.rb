require_relative '../../spec_helper'

describe "VagrantPlugins::ChefZero::Action::Upload" do

  before(:each) do

    # For now a silly helper to create fake nested env objects
    ui = double("bar")
    ui.stub(:warn).and_return(nil)
    $fake_chef_zero = double("foo")
    $fake_chef_zero.stub(:ui).and_return(ui)

    class DummyUpload < VagrantPlugins::ChefZero::Action::Upload

      def initialize(app, env)
        @env = {:chef_zero => $fake_chef_zero}
      end

    end
  end

  describe "Normalizing Cookbook Path" do

    describe "with a nil path" do

      it "should return an empty array" do
        path = nil
        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql []
      end

    end

    describe "with an empty array" do

      it "should return an empty array" do
        path = []
        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql []
      end

    end

    describe "with a non-empty array" do

      it "should return the given array" do
        path = ["foo"]
        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql path
      end

    end

    describe "with a string that is a path to valid cookbook with metadata.rb" do

      it "should return the given path in an array" do
        path = "foo"
        File.stub(:exists?).with("#{path}/metadata.rb").and_return(true)
        File.stub(:exists?).with("#{path}/metadata.json").and_return(false)

        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql [path]
      end

    end

    describe "with a string that is a path to valid cookbook with metadata.json" do

      it "should return the given path in an array" do
        path = "foo"
        File.stub(:exists?).with("#{path}/metadata.rb").and_return(false)
        File.stub(:exists?).with("#{path}/metadata.json").and_return(true)

        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql [path]
      end

    end

    describe "with a string that is a path to valid cookbooks directory" do

      it "should return the given path in an array" do
        path = "./foo/cookbooks"
        File.stub(:directory?).with(path).and_return(true)
        Dir.stub(:glob).with("#{path}/*").and_return(["#{path}/bar", "#{path}/baz"])

        File.stub(:exists?).and_return(false)
        File.stub(:exists?).with("#{path}/bar/metadata.rb").and_return(true)
        File.stub(:exists?).with("#{path}/baz/metadata.json").and_return(true)

        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql ["#{path}/bar", "#{path}/baz"]
      end

    end

    describe "with a string that not a valid path" do

      it "should send a UI warning and return an empty array" do
        path = "foo"
        File.stub(:exists?).and_return(false)
        File.stub(:directory?).and_return(false)

        d = DummyUpload.new("foo", "bar")
        d.select_cookbooks(path).should eql []
      end

    end

  end

end
