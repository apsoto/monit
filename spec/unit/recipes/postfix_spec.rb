require 'spec_helper'

describe 'monit::postfix' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new.converge(described_recipe)
  end

  # Temporary soultion for testing definitions/monitrc.erb without monky patch.
  # See http://amespinosa.wordpress.com/2013/05/06/testing-recipe-definitions-with-chefspec/
  it 'creates /etc/monit/conf.d/postfix.conf' do
      expect(chef_run).to create_template('/etc/monit/conf.d/postfix.conf').with(user: 'root', group: 'root', mode: 0644)
      file = chef_run.template('/etc/monit/conf.d/postfix.conf')
      expect(file).to notify('service[monit]').to(:restart)
  end

end
