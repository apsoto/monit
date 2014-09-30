require 'spec_helper'

describe 'monit::postgresql' do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it 'creates /etc/monit/conf.d/postgresql.conf' do
    expect(chef_run).to create_template('/etc/monit/conf.d/postgresql.conf').with(user: 'root', group: 'root', mode: 0644)
    
    expect(chef_run).to render_file('/etc/monit/conf.d/postgresql.conf').with_content('start program = "/etc/init.d/postgresql start"')
  end
end
