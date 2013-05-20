require 'spec_helper'

describe 'monit::resque' do
  def chef_run(monit_resque_attrs = {})
    @chef_run ||= ChefSpec::Runner.new do |node|
      node.set[:monit][:resque] = monit_resque_attrs
    end.converge described_recipe
  end

  it 'includes the default recipe' do
    chef_run({ queues: [{ worker_count: 1, queue_list: %w(apple) }] })

    expect(chef_run).to include_recipe 'monit::resque'
  end

  it 'creates the resque.conf' do
    chef_run({ queues: [{ queue_list: %w(apple banana peanut), worker_count: 1 }]})

    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('check process resque_worker_0')
    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('QUEUE=apple,banana,peanut')
  end

  it 'groups queues appropriately' do
    queues = [
      { queue_list: %w(tomato), worker_count: 2 },
      { queue_list: %w(apple banana carrot), worker_count: 3 },
      { queue_list: %w(plum orange), worker_count: 1 }
    ]
    chef_run({ queues: queues })

    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('QUEUE=tomato')
    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('QUEUE=plum,orange')
    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('QUEUE=apple,banana,carrot')
  end

  it 'gives each worker a unique name' do
    queues = [
      { queue_list: %w(tomato), worker_count: 2 }
    ]
    chef_run({ queues: queues })

    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('check process resque_worker_0')
    expect(chef_run).to render_file('/etc/monit/conf.d/resque.conf').with_content('check process resque_worker_1')
  end

  [0, -1].each do |worker_count|
    it 'should guard against an invalid number of workers' do
      lambda {
        chef_run({ queues: [{ queue_list: %w(apple), worker_count: worker_count }] })
      }.should raise_error ArgumentError, 'The number of workers for a given queue must be a positive integer.'
    end
  end
end
