default[:monit][:notify_email]          = "notify@example.com"

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 120

default[:monit][:mail_format][:subject] = "$SERVICE $EVENT"
default[:monit][:mail_format][:from]    = "monit@example.com"
default[:monit][:mail_format][:message]    = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

case node['platform']
  when "centos", "redhat", "fedora"
    default[:monit][:include_dir] = '/etc/monit.d'
  else
    default[:monit][:include_dir] = '/etc/monit/conf.d'
end
