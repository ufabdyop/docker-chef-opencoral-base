FROM ubuntu

ADD ./chef/base /chef

RUN apt-get -y update && \
	apt-get install -y openssh-server && \
	mkdir /var/run/sshd && \
	apt-get -y install curl build-essential libxml2-dev libxslt-dev git autoconf && \
	(curl -L https://www.opscode.com/chef/install.sh | bash) && \
	(echo "gem: --no-ri --no-rdoc" > ~/.gemrc) && \
	/opt/chef/embedded/bin/gem install librarian-chef 

RUN (cd /chef; /opt/chef/embedded/bin/librarian-chef install) && \
	(cd /chef; chef-solo -c solo.rb -j node.json) && \
	#apt-get install -y icedtea-netx && \
	rm -rf /chef /var/lib/apt/lists/* 

# ssh
EXPOSE 22

# replace this with your main file
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD [ "/usr/local/bin/run" ]
