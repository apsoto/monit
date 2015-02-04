package "monit"

cookbook_file "/etc/default/monit" do
  source "monit.default"
  owner "root"
  group "root"
  mode 0644
  only_if { platform?("ubuntu") || platform?("debian") }
end

case node['platform']
when 'ubuntu', 'debian'
  node.default['monit']['conf_file'] = '/etc/monit/monitrc'
  node.default['monit']['conf_dir'] = '/etc/monit/conf.d/'

when 'redhat', 'fedora', 'centos'  # ~FC024 
  node.default['monit']['conf_file'] = '/etc/monit.conf'
  node.default['monit']['conf_dir'] = '/etc/monit.d/'
end

directory node['monit']['conf_dir'] do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

template node['monit']['conf_file'] do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, "service[monit]", :delayed
end

service "monit" do
  action [:enable, :start]
  supports [:start, :restart, :stop]
end
