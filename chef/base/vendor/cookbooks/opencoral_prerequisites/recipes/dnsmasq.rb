package "dnsmasq"

directory "/etc/dnsmasq.d"

cookbook_file "dnsmasq.conf" do
  path "/etc/dnsmasq.conf"
end

cookbook_file "dnsmasq.hostsfile" do
  path "/etc/dnsmasq.d/0hosts"
end

cookbook_file "resolv.dnsmasq.conf" do
  path "/etc/resolv.dnsmasq.conf"
end
