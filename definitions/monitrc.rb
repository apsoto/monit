# reload      Reload monit so it notices the new service.  :delayed (default) or :immediately.
define :monitrc, :enable => true, :reload => :delayed, :source => "#{params[:name]}.conf.erb", :cookbook => "monit" do
  if params[:enable]
    template "/etc/monit/conf.d/#{params[:name]}.conf" do
      owner "root"
      group "root"
      mode 0644
      source params[:source]
      cookbook params[:cookbook]
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
