require 'spec_helper'

describe 'monit::default' do
  context "with default attributes" do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'creates /etc/monit/conf.d/' do
      expect(chef_run).to create_directory('/etc/monit/conf.d/').with(user: 'root', group: 'root', mode: 0755)
    end

    it 'creates /etc/monit/monitrc' do
      expect(chef_run).to create_template('/etc/monit/monitrc').with(user: 'root', group: 'root', mode: 0700)
      file = chef_run.template('/etc/monit/monitrc')
      expect(file).to notify('service[monit]').to(:restart)

      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set daemon 60\n\s*with start delay 120$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set httpd port 3737/)

      expect(chef_run).not_to render_file('/etc/monit/monitrc').with_content(/set mailserver/)
      expect(chef_run).not_to render_file('/etc/monit/monitrc').with_content(/set mail-format/)
      expect(chef_run).not_to render_file('/etc/monit/monitrc').with_content(/set alert/)
    end

    it 'enables the service' do
      expect(chef_run).to enable_service('monit') 
    end

    it 'start the service' do
      expect(chef_run).to start_service('monit') 
    end

    it 'does not email notifications' do
      expect(chef_run).not_to render_file('/etc/monit/monitrc').with_content(/set alert /)
    end
  end

  context "with configuration" do
    let(:chef_run) do
      runner = ChefSpec::Runner.new do |node|
        node.set[:monit][:notify_email] = 'johndoe@example.com'
        node.set[:monit][:logfile] = '/var/log/monit.log'
        node.set[:monit][:poll_period] = 30         
        node.set[:monit][:poll_start_delay] = 90
        node.set[:monit][:mail_format][:subject] = 'Hello from monit'
        node.set[:monit][:mail_format][:from] = 'monit@example.com'
        node.set[:monit][:mail_format][:message] = 'Hello!'
        node.set[:monit][:mailserver][:host] = 'smtp.example.com'
        node.set[:monit][:mailserver][:hostname] = 'mail.hostname.com'
        node.set[:monit][:mailserver][:port] = 587
        node.set[:monit][:mailserver][:username] = 'johndoe'
        node.set[:monit][:mailserver][:password] = 'secret'
        node.set[:monit][:mailserver][:password_suffix] = 'smtp'
        node.set[:monit][:mailserver][:encryption] = 'SSLV2'
        node.set[:monit][:mailserver][:timeout] = 10
        node.set[:monit][:port] = 8000
        node.set[:monit][:address] = '192.168.0.1'
        node.set[:monit][:ssl] = true
        node.set[:monit][:allow] = ["localhost", '192.168.0.2']
        node.set[:monit][:username] = 'johndoe'
        node.set[:monit][:password] = 'secret'
      end.converge(described_recipe)
    end

    it 'creates /etc/monit/monitrc' do
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set daemon 30\n\s*with start delay 90$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(%r|set logfile /var/log/monit.log$|)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set mailserver smtp.example.com port 587\n\s*using HOSTNAME "mail.hostname.com"\n\s*username "johndoe"\n\s*password "secret" smtp\n\s*using SSLV2\n\s*with timeout 10 seconds$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set mail-format {\n\s*from: monit@example.com\n\s*subject: Hello from monit\n\s*message: Hello!$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set alert johndoe@example.com NOT ON { action, instance, pid, ppid }$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/set httpd port 8000\n\s*use address 192.168.0.1\n\s*allow localhost\n\s*allow 192.168.0.2$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(/allow johndoe:secret$/)
      expect(chef_run).to render_file('/etc/monit/monitrc').with_content(%r|ssl enable\n\s*pemfile /etc/monit/monit.pem$|)
    end
  end

  context "on ubuntu" do
    let(:chef_run) do
      runner = ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04').converge(described_recipe)
    end

    it 'creates /etc/default/monit' do
      expect(chef_run).to create_cookbook_file('/etc/default/monit').with(user: 'root', group: 'root', mode: 0644)
    end
  end

end
