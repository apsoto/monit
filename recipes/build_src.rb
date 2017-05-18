
%w{build-essential wget libyaml-dev zlib1g-dev libreadline-dev libssl-dev tk-dev libgdbm-dev}.each do |pkg|
  package pkg do
    action [:install]
  end
end

script "compile_monit" do
    interpreter "bash"
    user "root"
    cwd "/tmp/"
    creates "/usr/local/bin/monit"
    code <<-EOH
    STATUS=0
    wget http://mmonit.com/monit/dist/monit-5.5.tar.gz || STATUS=1
    tar xvzf monit-5.5.tar.gz || STATUS=1
    cd /tmp/monit-5.5 || STATUS=1
    ./configure --without-pam || STATUS=1
    make || STATUS=1
    make install || STATUS=1
    cd ../ && rm -rf /tmp/monit* || STATUS=1
    exit $STATUS
    EOH
end
