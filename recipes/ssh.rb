include_recipe "monit"

if node.recipe?("openssh")
  monit_conf "sshd" do
    pid "/var/run/sshd.pid"
    start "/usr/sbin/service ssh start"
    stop "/usr/sbin/service ssh stop"
    rule "IF FAILED PORT 22 PROTOCOL ssh 4 TIMES WITHIN 6 CYCLES THEN RESTART"
  end
else
  log("The openssh recipe does not seem to be loaded.") { level :warn }
end