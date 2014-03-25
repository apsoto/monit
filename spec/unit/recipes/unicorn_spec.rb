require 'spec_helper'

describe 'monit::unicorn' do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it 'creates /etc/monit/conf.d/unicorn.conf' do
    expect(chef_run).to create_template('/etc/monit/conf.d/unicorn.conf').with(user: 'root', group: 'root', mode: 0644)

    # Can't assert on definitions without a hairy monkey patch: http://amespinosa.wordpress.com/2013/05/06/testing-recipe-definitions-with-chefspec/
    #expect(chef_run).to create_template('/etc/monit/conf.d/unicorn_master.conf').with_content('start program "/etc/init.d/unicorn start"')
  end
end
