bash "install ant" do
  code <<-EOF
    curl -o /tmp/ant.tar.gz http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz
    cd /tmp
    tar xvzf ant.tar.gz
    mv apache-ant-1.9.4 /usr/local
    ln -s /usr/local/apache-ant-1.9.4 /usr/local/ant
    ln -s /usr/local/ant/bin/ant /usr/local/bin/ant
  EOF
end
