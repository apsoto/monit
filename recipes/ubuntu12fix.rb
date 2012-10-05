# Working init script, fix for: https://bugs.launchpad.net/ubuntu/+source/monit/+bug/993381
cookbook_file "/etc/init.d/monit" do
  source 'init-monit-ubuntu12.sh'
  owner 'root'
  group 'root'
  mode '0755'
end