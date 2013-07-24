require_relative '../spec_helper'

describe 'VagrantPlugins::ChefZero::ServerHelpers' do

  before do
  class DummyClass
    include VagrantPlugins::ChefZero::ServerHelpers
  end

  @d = DummyClass.new
  end

  describe "chef_zero_server_running?" do

    it "should have an chef_zero_server_running method" do
      @d.must_respond_to(:chef_zero_server_running?)
    end

    describe "server is running" do

      before do
        @d.stubs(:get_chef_zero_server_pid).returns("bar")
      end

      it "should show that the server is running" do
        port = "foo"
        @d.chef_zero_server_running?(port).must_equal true
      end

    end

    describe "server not running" do

      before do
        @d.stubs(:get_chef_zero_server_pid).returns(nil)
      end

      it "should show that the server is running" do
        port = "foo"
        @d.chef_zero_server_running?(port).must_equal false
      end

    end

  end

  describe "stop_chef_zero" do

    it "should have an stop_chef_zero method" do
      @d.must_respond_to(:stop_chef_zero)
    end

    describe "server is running" do

      before do
        @d.stubs(:chef_zero_server_running?).returns(true)
        @d.stubs(:`).returns

      end

    end

  end

end