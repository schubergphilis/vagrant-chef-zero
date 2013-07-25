require_relative '../spec_helper'

describe 'VagrantPlugins::ChefZero::EnvHelpers' do

  before do
  class DummyClass
    include VagrantPlugins::ChefZero::EnvHelpers
  end

  @d = DummyClass.new
  end

  describe "chef_zero_server_running?" do

    it "should have an chef_zero_server_running method" do
      @d.must_respond_to(:chef_zero_server_running?)
    end

  end

end