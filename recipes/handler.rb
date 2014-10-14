# Unmonitor services that might be manipulated by the chef run
e = execute "monit unmonitor all" do
  action :nothing
  only_if "ps -e | grep -q `cat /var/run/monit.pid`"
  ignore_failure true
end
e.run_action(:run)

# Monitor chef-client in case it bails mid-run
e = execute "monit monitor chef-client" do
  action :nothing
  only_if "ps -e | grep -q `cat /var/run/monit.pid` && monit summary | grep -q \"Process 'chef-client'\""
  ignore_failure true
end
e.run_action(:run)

# Install monit chef handler
include_recipe "chef_handler"

directory node["chef_handler"]["handler_path"] do
  owner "root"
  group "root"
  mode  "0755"
end

handler_path = ::File.join(node["chef_handler"]["handler_path"], "monit_handler.rb")
cookbook_file handler_path do
  owner "root"
  group "root"
  mode  "0644"
end

chef_handler "MonitHandler" do
  source handler_path
  action :enable
  arguments :poll_period => node["monit"]["poll_period"]
end