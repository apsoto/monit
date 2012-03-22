default[:monit][:logfile]               = "syslog facility log_daemon"

default[:monit][:notify][:enable]       = false
default[:monit][:notify][:email]        = "notify@example.com"

default[:monit][:httpd][:enable]        = false
default[:monit][:httpd][:port]          = 3737
default[:monit][:httpd][:address]       = "localhost"
default[:monit][:httpd][:allow]         = %w{localhost}

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 120

default[:monit][:mail][:server]           = "localhost"
default[:monit][:mail][:format][:subject] = "$SERVICE $EVENT"
default[:monit][:mail][:format][:from]    = "monit@example.com"
default[:monit][:mail][:format][:message]    = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

default[:monit][:queue][:location]      = "/var/monit"  # base directory where events will be stored
default[:monit][:queue][:slots]         = nil           # limit the size of the queue