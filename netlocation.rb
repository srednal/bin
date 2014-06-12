#!/usr/bin/env ruby
# Test network for work/vpn/home based on ip/vpn
require 'ipaddr'

WORK_IPs = [ '128.222.0.0/16',  # The office network, roughly
             '10.162.0.0/16' ]  # CORP-W1F1, roughly

# see if VPN is connected
def vpn?
    vpn = false;
    IO.popen( '/opt/cisco/anyconnect/bin/vpn status' ) do |out|
        out.each do |line|
            vpn |= line =~ />> state: Connected/
        end
    end
    vpn
end

# see if the vpn app is running
def vpn_app?
    vpn = false
    IO.popen( 'ps -ewwo pid,args' ) do |out|
        out.each do |line| 
            vpn |= line =~ /Cisco\ AnyConnect\ Secure\ Mobility\ Client\.app/
        end
    end
    vpn
end

# are we on work network
def work?
    ! WORK_IPs.index { |ip| IPAddr.new(ip).include?(local_ip) }.nil?
end

# lookup local ip addr
def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
  UDPSocket.open do |s|
    s.connect '192.0.43.8', 1  # IP is anything (not localhost though) - this is icann.org
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

def location
    if vpn? 
        :vpn
    elsif work?
        :work
    else
        :other
    end
end

########################################

# sleep 5   # let things settle down (assuming launch agent trigger)

puts "local_ip = #{local_ip}"
puts "vpn? = #{vpn?}"
# puts "vpn_app? = #{vpn_app?}"
puts "work? = #{work?}"
