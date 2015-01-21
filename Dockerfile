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
ADD  chef/active-cookbook/opencoral_prerequisites/metadata.rb                      /chef/vendor/cookbooks/opencoral_prerequisites/metadata.rb
ADD  chef/active-cookbook/opencoral_prerequisites/README.md                        /chef/vendor/cookbooks/opencoral_prerequisites/README.md
ADD  chef/active-cookbook/opencoral_prerequisites/recipes/default.rb               /chef/vendor/cookbooks/opencoral_prerequisites/recipes/default.rb

### Run librarian to get dependencies
RUN cd /chef; /opt/chef/embedded/bin/librarian-chef install

### Run recipes
RUN cd /chef; chef-solo -c solo.rb -j node.json -o 'opencoral_prerequisites::default'

### Recipe Under Active Development (use cached runs of earlier reciped)
ADD chef/active-cookbook/opencoral_prerequisites/recipes/dnsmasq.rb                 /chef/vendor/cookbooks/opencoral_prerequisites/recipes/dnsmasq.rb
ADD chef/active-cookbook/opencoral_prerequisites/files/default/dnsmasq.conf         /chef/vendor/cookbooks/opencoral_prerequisites/files/default/dnsmasq.conf
ADD chef/active-cookbook/opencoral_prerequisites/files/default/dnsmasq.hostsfile    /chef/vendor/cookbooks/opencoral_prerequisites/files/default/dnsmasq.hostsfile
ADD chef/active-cookbook/opencoral_prerequisites/files/default/resolv.dnsmasq.conf  /chef/vendor/cookbooks/opencoral_prerequisites/files/default/resolv.dnsmasq.conf
RUN cd /chef; /opt/chef/embedded/bin/librarian-chef install
RUN cd /chef; chef-solo -c solo.rb -j node.json -o 'opencoral_prerequisites::dnsmasq'

### Install DB
ADD chef/active-cookbook/opencoral_prerequisites/files/default                                   /chef/vendor/cookbooks/opencoral_prerequisites/files/default
ADD chef/active-cookbook/opencoral_prerequisites/files/default/pg_hba.conf                       /chef/vendor/cookbooks/opencoral_prerequisites/files/default/pg_hba.conf
ADD chef/active-cookbook/opencoral_prerequisites/files/default/Pg83-implicit-casts.sql_id22      /chef/vendor/cookbooks/opencoral_prerequisites/files/default/Pg83-implicit-casts.sql_id22
ADD chef/active-cookbook/opencoral_prerequisites/files/default/postgresql.key                    /chef/vendor/cookbooks/opencoral_prerequisites/files/default/postgresql.key
ADD chef/active-cookbook/opencoral_prerequisites/files/default/postgresql.pem                    /chef/vendor/cookbooks/opencoral_prerequisites/files/default/postgresql.pem
ADD chef/base/vendor/cookbooks/postgresql                                         /chef/vendor/cookbooks/postgresql
ADD chef/active-cookbook/opencoral_prerequisites/recipes/database.rb                 /chef/vendor/cookbooks/opencoral_prerequisites/recipes/database.rb
RUN cd /chef; /opt/chef/embedded/bin/librarian-chef install
RUN cd /chef; chef-solo -c solo.rb -j node.json -o 'opencoral_prerequisites::database'

# ### Set Locale
ADD  chef/active-cookbook/opencoral_prerequisites/recipes/set_locale.rb                /chef/vendor/cookbooks/opencoral_prerequisites/recipes/set_locale.rb
RUN cd /chef; /opt/chef/embedded/bin/librarian-chef install
RUN cd /chef; chef-solo -c solo.rb -j node.json -o 'opencoral_prerequisites::set_locale'

### Clean up
RUN /bin/bash -c 'rm -rf /chef/jdk*tar.gz /chef/secret'

# ssh
EXPOSE 22

# replace this with your main file
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD [ "/usr/local/bin/run" ]
