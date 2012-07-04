# reload: Reload monit so it notices the new service.  :delayed (default) or :immediately.
# action: :enable To create the monitoring config (default), or :disable to remove it.
define :monitrc, :action => :enable, :reload => :delayed do
  if params[:action] == :enable
    template "/etc/monit/conf.d/#{params[:name]}.conf" do
      owner "root"
      group "root"
      mode 0644
      source "#{params[:name]}.conf.erb"
      cookbook "monit"
      variables params
      notifies :restart, resources(:service => "monit"), params[:reload]
      action :create
    end
  else
    template "/etc/monit/conf.d/#{params[:name]}.conf" do
      action :delete
      notifies :restart, resources(:service => "monit"), params[:reload]
    end
  end
end