package "monit" do
    action :remove
end

remote_file "/tmp/monit-5.6.tar.gz" do
  source "http://mmonit.com/monit/dist/monit-5.6.tar.gz"
  owner "root"
  group "root"
  mode 0644
end

script "compile_monit" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  creates "/usr/local/share/man/man1/monit.1"
  code <<-EOH
    STATUS=0
    tar xvzf monit-5.6.tar.gz || STATUS=1
    cd monit-5.6 || STATUS=1
    ./configure --without-pam --without-ssl || STATUS=1
    make || STATUS=1
    make install || STATUS=1
    cd /tmp
    rm -rf monit-5.6*
    exit $STATUS
  EOH
end


if platform?("ubuntu")
  cookbook_file "/etc/default/monit" do
    source "monit.default"
    owner "root"
    group "root"
    mode 0644
  end
end

cookbook_file "/etc/init.d/monit" do
  action :create
  owner "root"
  group "root"
  mode 0755
  source 'init-monit-ubuntu12.sh'
end
service "monit" do
  action [:enable, :start]
  enabled true
  supports [:start, :restart, :stop]
end

directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

template "/etc/monitrc" do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, resources(:service => "monit"), :delayed
end
