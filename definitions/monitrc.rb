# reload      Reload monit so it notices the new service.  :delayed (default) or :immediately.
define :monitrc, :action => :enable, :reload => :delayed do
  if params[:enable]
    template "/etc/monit/conf.d/#{name}.conf" do
      owner "root"
      group "root"
      mode 0644
      source "#{name}.conf.erb"
      variables params
      notifies :restart, resources(:service => "monit"), params[:reload]
      action :create
    end
  else
    template "/etc/monit/conf.d/#{name}.conf" do
      action :delete
      notifies :restart, resources(:service => "monit"), params[:reload]
    end
  end
end