package "monit" do
  action :install
end

#### prepare directories and additional things ###
include_dir = node[:monit][:include_dir]
if platform?(%W(fedora centos redhat))
  directory include_dir do
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
else
  #assume debian|ubuntu
  directory include_dir do
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
  cookbook_file "/etc/default/monit" do
    source "monit.default"
    owner "root"
    group "root"
    mode 0644
  end
end
cookbook_file "#{include_dir}/dummy.conf" do
  #this is a dummy file in conf.d, monit will not start with this directory empty
  source "dummy.conf"
end

#### main conf ####
if platform?(%W(fedora centos redhat))
  template "monit_conf" do
    path "/etc/monit.conf"
    source 'monitrc.erb'
    owner "root"
    group "root"
    variables :include_path => "#{include_dir}/*.conf"
  end
else
  #assume debian|ubuntu
  template "monit_conf" do
    path "/etc/monit/monitrc"
    source 'monitrc.erb'
    owner "root"
    group "root"
    variables :include_path => "#{include_dir}/*.conf"
  end
end

#### service ####
supports = [:start, :restart, :stop]
if platform?(%W(fedora centos redhat))
  supports << :reload
end

service "monit" do
  action [:enable, :start]
  supports supports
  subscribes :restart, resources(:template => "monit_conf"), :immediate
end
