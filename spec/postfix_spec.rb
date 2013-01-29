require 'spec_helper'

describe 'monit::postfix' do
  let(:chef_run) { runner.converge 'monit::postfix' }

  it "includes the default recipe" do
    chef_run.should include_recipe "monit"
  end

  it "installs postfix" do
    chef_run.should install_package "postfix"
  end

  it "creates the postfix.conf" do
    chef_run.should create_file_with_content "/etc/monit/conf.d/postfix.conf", "CHECK PROCESS postfix WITH PIDFILE /var/spool/postfix/pid/master.pid"
  end
end
