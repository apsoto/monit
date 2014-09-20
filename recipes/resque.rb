include_recipe "monit"

node['monit']['resque']['queues'].each do |queue|
  if queue['worker_count'] <= 0
    raise ArgumentError, 'The number of workers for a given queue must be a positive integer.'
  end
end

monitrc "resque"
