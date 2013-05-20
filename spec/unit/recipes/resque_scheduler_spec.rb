require 'spec_helper'

describe 'monit::resque_scheduler' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:monit][:resque][:app_root] = '/www/myapp-test/current'
    end.converge(described_recipe)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe 'monit::resque_scheduler'
  end

  it "creates the resque_scheduler.conf" do
    expect(chef_run).to render_file("/etc/monit/conf.d/resque_scheduler.conf")
                        .with_content("check process resque_scheduler with pidfile /www/myapp-test/current")
  end
end
