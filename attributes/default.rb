default[:monit][:notify][:enable]       = false
default[:monit][:notify][:email]        = "notify@example.com"

default[:monit][:httpd][:enable]        = false
default[:monit][:httpd][:port]          = 3737
default[:monit][:httpd][:address]       = localhost
default[:monit][:httpd][:allow]         = %w{localhost}

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 120

default[:monit][:mail_format][:subject] = "$SERVICE $EVENT"
default[:monit][:mail_format][:from]    = "monit@example.com"
default[:monit][:mail_format][:message]    = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS
