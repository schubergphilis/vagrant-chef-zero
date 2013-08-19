require_relative '../spec_helper'
require 'chef_zero/server'

describe VagrantPlugins::ChefZero::ServerHelpers do
  
  class DummyServerHelpers
    include VagrantPlugins::ChefZero::ServerHelpers
  end

  class DummyChefZeroEnv < VagrantPlugins::ChefZero::Env
  end

  before do
    # We need to prevent ChefZero::Server from actually binding to any addresses
    ::Puma::Server.any_instance.stub(:add_tcp_listener)
  end

  let(:d) { DummyServerHelpers.new }
  let(:env) { 
    h = Hash.new
    h[:chef_zero] = DummyChefZeroEnv.new
    h[:machine] = double('machine')
    h
  }

  describe "#start_chef_zero" do 

    before do
      d.stub(:get_port) { "4000" }
      d.stub(:get_host) { "127.0.0.1" }
    end

    context "when chef-zero server is already running" do

      it "should take no action" do
        env[:chef_zero].stub_chain(:server, :running?) { true }
        env[:chef_zero].stub_chain(:server, :start_background)
        d.start_chef_zero(env)
        env[:chef_zero].server.should_not have_received(:start_background)
      end

    end

    context "when chef-zero server is not running" do

      it "should start the server in the background" do
        env[:chef_zero].stub_chain(:server, :running?) { false }
        env[:chef_zero].stub_chain(:server, :start_background) do
          env[:chef_zero].stub_chain(:server, :running?) { true }
        end
        d.start_chef_zero(env)
        env[:chef_zero].server.should have_received(:start_background)
      end

    end
  end # describe #start_chef_zero

  describe "#stop_chef_zero" do

    before do 
      env[:chef_zero].stub_chain(:server, :running?) { true }
    end

    it "should stop server" do
      env[:chef_zero].stub_chain(:server, :stop)
      d.stop_chef_zero(env)
      env[:chef_zero].server.should have_received(:stop)
    end

  end # describe #stop_chef_zero

end