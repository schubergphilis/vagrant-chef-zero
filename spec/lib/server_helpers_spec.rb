require_relative '../spec_helper'
require 'chef_zero/server'

describe VagrantPlugins::ChefZero::ServerHelpers do
  
  class DummyServerHelpers
    include VagrantPlugins::ChefZero::ServerHelpers
  end

  class DummyChefZeroEnv < VagrantPlugins::ChefZero::Env
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
      d.stub(:fork_process) { }
      d.stub(:wait_for_server_to_start) { true }
      ENV['GEM_PATH'] += ":/foo/bar/vagrant.d/bin"
    end

    context "when chef-zero server is already running" do

      it "should take no action" do
        d.stub(:port_open?) { true }
        d.stub(:is_a_chef_zero_server?) { true }
        d.start_chef_zero(env)
        d.should_not have_received(:fork_process)
      end

    end

    context "when chef-zero server is not running" do

      it "should start the server in the background" do
        d.start_chef_zero(env)
        d.should have_received(:fork_process)
      end

    end
  end # describe #start_chef_zero

  describe "#stop_chef_zero" do

    before do 
      d.stub(:get_host) { "127.0.0.1" }
      d.stub(:get_port) { "4000" }
      d.stub(:kill_process) { }
      d.stub(:port_open?) { true }
      d.stub(:get_chef_zero_server_pid) { 1234 }
      d.stub(:is_a_chef_zero_server?) { true }
    end

    it "should stop server" do
      d.stop_chef_zero(env)
      d.should have_received(:kill_process)
    end

  end # describe #stop_chef_zero

end