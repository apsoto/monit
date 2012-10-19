include_recipe "monit"

if node.recipe?("postfix")
  monit_conf "postfix" do
    pid "/var/spool/postfix/pid/master.pid"
    start "/etc/init.d/postfix start"
    stop "/etc/init.d/postfix stop"
    group "mail"
    rule [
      "IF FAILED PORT 25 PROTOCOL smtp THEN restart",
      "IF 5 RESTARTS WITHIN 5 CYCLES THEN timeout"
    ]
  end
else
  log("the postfix recipe does not seem to be loaded.") { level :warn }
end
