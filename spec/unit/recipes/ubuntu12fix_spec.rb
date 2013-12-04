require 'spec_helper'

describe 'monit::ubuntu12fix' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new.converge(described_recipe)
  end

  it 'overrides /etc/init.d/monit' do
    # I have no idea why mode doesn't work without single quotes.
    expect(chef_run).to create_cookbook_file('/etc/init.d/monit').with(user: 'root', group: 'root', mode: '0755')
  end
end
