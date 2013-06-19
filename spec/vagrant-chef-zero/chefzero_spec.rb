require 'spec_helper'

describe VagrantPlugins::ChefZero do

  describe "#up" do
    
    # It may be possible that there is already a Chef-Zero server running. What should we be doing here?
    context "chef-zero server is already running" do

    end

    context "chef-zero server is not running" do

      describe VagrantPlugins::ChefZero::Action::Start

      describe VagrantPlugins::ChefZero::Action::Upload

    end

  end

  describe "#provision" do

    describe VagrantPlugins::ChefZero::Action::Upload

  end
  
  describe "#destroy" do

    describe VagrantPlugins::ChefZero::Action::Stop

  end

end
