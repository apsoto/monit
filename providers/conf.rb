action :create do
  if new_resource.type == :file && !new_resource.path
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a path attribute.")
  end
  if new_resource.type == :process && !new_resource.pid
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a pid attribute.")
  end

  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    owner "root"
    group "root"
    mode 0644
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :depends => new_resource.depends,
      :group => new_resource.group,
      :name => new_resource.name,
      :path => new_resource.path,
      :pid => new_resource.pid,
      :rule => new_resource.rule,
      :start => new_resource.start,
      :stop => new_resource.stop,
      :type => new_resource.type
    )
    notifies :restart, resources(:service => "monit"), new_resource.reload
  end
end

action :delete do
  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    action :delete
    source new_resource.template
    cookbook new_resource.cookbook
    notifies :restart, resources(:service => "monit"), new_resource.reload
  end
end