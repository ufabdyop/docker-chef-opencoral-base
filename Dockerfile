FROM ubuntu

# Install SSH Server
RUN apt-get -y update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# ssh
EXPOSE 22

#INSTALL CHEF
RUN apt-get -y install curl build-essential libxml2-dev libxslt-dev git autoconf
RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

#INSTALL librarian
RUN /opt/chef/embedded/bin/gem install librarian-chef

ADD ./chef/base /chef
WORKDIR /chef

### Opencoral Cookbook Files ###
ADD  chef/active-cookbook/opencoral_prerequisites                      /chef/vendor/cookbooks/opencoral_prerequisites

RUN cd /chef; /opt/chef/embedded/bin/librarian-chef install
RUN cd /chef; chef-solo -c solo.rb -j node.json

### Clean up
RUN /bin/bash -c 'rm -rf /chef/jdk*tar.gz /chef/secret'

# ssh
EXPOSE 22

# replace this with your main file
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN apt-get install -y icedtea-netx
CMD [ "/usr/local/bin/run" ]
