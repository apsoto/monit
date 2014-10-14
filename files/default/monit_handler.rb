require "rubygems"
require "chef"
require "chef/handler"

class MonitHandler < Chef::Handler

  def initialize(opts = {})
    @poll_period = opts[:poll_period] || 1
  end

  def success
    Chef::Log.info "Monit monitor all succeeded"
  end

  def failure
    Chef::Log.warn "Monit monitor all failed"
  end

  def report
    if system("ps -e | grep `cat /var/run/monit.pid`")
      return success if system("monit monitor all")
      failure
      Chef::Log.warn "Waiting #{@poll_period} seconds before trying again..."
      return success if system("sleep #{@poll_period} && monit monitor all")
      failure
    end
  end

end