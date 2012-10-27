require "rubygems"
require "chef"
require "chef/handler"

class MonitHandler < Chef::Handler

  def initialize(opts = {})
    @poll_period = opts[:poll_period] || 1
  end

  def report
    if system("ps -e | grep `cat /var/run/monit.pid`")
      did_monitor = system("monit monitor all")
      if did_monitor
        Chef::Log.info "Monit monitor all succeeded"
      else
        Chef::Log.info "Monit monitor all failed, waiting #{@poll_period} seconds before trying again"
        did_monitor = system("sleep #{@poll_period} && monit monitor all")
      end
      Chef::Log.info("Monit monitor all failed") unless did_monitor
    end
  end

end