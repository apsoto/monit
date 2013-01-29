require 'chefspec'
require 'fauxhai'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    # Change this to whatever OS you want to stub out, or move it into a before block if different spec files need different OSes.
    Fauxhai.mock(platform: 'ubuntu', version: '10.04')
  end
end

# Chef normally defaults to the '_default' environment. For tests, run by default in the 'test' environment.
def runner(environment = "test")
  # A workaround so that ChefSpec can work with Chef environments (from https://github.com/acrmp/chefspec/issues/54)

  @runner ||= ChefSpec::ChefRunner.new do |node|
    env = Chef::Environment.new
    env.name environment

    node.stub(:chef_environment).and_return env.name
    Chef::Environment.stub(:load).and_return env
  end
end
