package "monit" do
  action :install
end

case node['platform_family']
when "debian"
  ruby_block 'update /etc/default/monit' do
    block do
      require 'chef/util/file_edit'
      monit_default = Chef::Util::FileEdit.new("/etc/default/monit")
      monit_default.search_file_replace_line(/^startup=0/, "startup=1")
      monit_default.write_file
    end
    action :create
    ignore_failure true
  end
end

service "monit" do
  action [:enable, :start]
  enabled true
  supports [:start, :restart, :stop]
end

template "/etc/monit/monitrc" do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, resources(:service => "monit"), :delayed
end

directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

node['monit']['include'].each do |recipe|
  include_recipe "monit::#{recipe}"
end