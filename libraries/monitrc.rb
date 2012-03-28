class Chef
  class Recipe
    # name        The name of the service.  Looks for a template named NAME.conf
    # variables   Hash of variables to pass to the template
    # reload      Reload monit so it notices the new service.  :delayed (default) or :immediately.
    def monitrc(name, variables={}, reload = :delayed)
      Chef::Log.info "Making monitrc for: #{name}"

      action = :restart
      if platform?(%W(fedora centos redhat))
        action = :reload
      end

      template "#{node[:monit][:include_dir]}/#{name}.conf" do
        owner "root"
        group "root"
        mode 0644
        #this should be "monit/#{name}.conf.erb" or "#{name}.monit.conf.erb" to not conflict with other conf files
        #but this is a non backward compat change. I'll leave it to the owner of the cookbook
        source "#{name}.conf.erb"
        variables variables
        notifies action, resources(:service => "monit"), reload
        action :create
      end
    end
  end
end  
