# Overview #
Chef cookbook for the [monit](http://mmonit.com/monit/) monitoring and
management tool.

## Supported Platforms ##
 * Debian
 * Ubuntu


# How to add to your cookbook repository #

## Download the tarball ##
It's up on the opscode
[cookbook community](http://community.opscode.com/cookbooks/monit) site.

## Vendor via knife ##

    $ knife cookbook site download monit

## Track upstream changes via git ##
I use git submodules for my chef repos so I can push/pull changes with minimal
hassle.

For more info, check out the [Pro Git](http://progit.org/book/ch6-6.html) book.

#### Add the monit repo ####

    $ cd YOUR_REPO_ROOT
    $ git submodule add git://github.com/apsoto/monit.git cookbooks/monit

#### Use librarian chef ####
Add this line to your Cheffile:
  $ cookbook "monit"

For more info, see [librarian-chef](http://github.com/applicationsonline/librarian).


# Usage #

Include the recipe `monit` somewhere in your run list.  This will install monit, make sure it is running, and create the monitrc file.

## Attributes ##

See [default.rb](http://github.com/apsoto/monit/blob/master/attributes/default.rb) for a list of available variables.

### Included Recipes ###

Built in Recipes
  * ssh (depends on openssh cookbook)
  * postfix (depends on postfix cookbook)

Add the available recipes to by defining the `node['monit']['include']` array or call them explicately `monit::ssh`.


# LWRP #

This a simple resource implementation that creates monit conf files.  It does no validation, so be careful.
  
See [conf.rb](http://github.com/apsoto/monit/blob/master/resources/conf.rb) for a list of available attributes and their defaults.

Eample with all attributes:
    monit_conf "test" do
      type :process # :process requires pid and :file requires path
      pid "/var/run/test.pid"
      path "/var/bin/test"
      start "/usr/sbin/service test start"
      stop "/usr/sbin/service test stop"
      group "test" # string or array
      depends "test_file" # string or array
      rule "IF FAILED PORT 22 PROTOCOL test 4 TIMES WITHIN 6 CYCLES THEN RESTART" # string or array
      cookbook "my_cookbook" # which cookbook to look for the template file.
      template "my_conf.erb" # override default template
    end

Eample process:

    monit_conf "sshd" do
      pid "/var/run/sshd.pid"
      start "/usr/sbin/service ssh start"
      stop "/usr/sbin/service ssh stop"
      rule "IF FAILED PORT 22 PROTOCOL ssh 4 TIMES WITHIN 6 CYCLES THEN RESTART"
    end

Outputs the sshd.conf file:

    check process sshd
      with pidfile /var/run/sshd.pid
      start program = "/usr/sbin/service ssh start"
      stop program = "/usr/sbin/service ssh stop"
      IF FAILED PORT 22 PROTOCOL ssh 4 TIMES WITHIN 6 CYCLES THEN RESTART

Eample file:

    monit_conf "mysql_bin" do
      type :file
      path "/opt/mysql/bin/mysqld"
      group "database"
      rule [
        "if failed checksum then unmonitor",
        "if failed permission 755 then unmonitor",
        "if failed uid root then unmonitor",
        "if failed gid root then unmonitor"
      ]
    end

Outputs the mysql_bin.conf file:

    check file mysql_bin 
      with path /opt/mysql/bin/mysqld
      group database
      if failed checksum then unmonitor
      if failed permission 755 then unmonitor
      if failed uid root then unmonitor
      if failed gid root then unmonitor


History
=======

version 0.7
-----------
 * create /etc/monit/conf.d.  Thanks Karel Minarik (https://github.com/karmi)

version 0.6
-----------
 * Released to github
 * Defaults no alert on ACTION event.
   When you manually stop/start a service, alerting me about what I just did isn't useful.

