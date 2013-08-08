#!/usr/bin/env ruby
#
# Wrap a web page in RSS.  Use from NetNewsWire (or whatever) to see changes in
# web pages as feeds.
#
# Usage: webwatch.rb http://www.something.com/etc
#
# Pings site each time run, therefore use NNW's refresh period to keep from spamming the site
# Relies on web server returning a valid last_modified header, otherwise NNW will see every
#   refresh as unread
# May not work for all sites, but should be pretty close (works for me)

require 'open-uri'
require 'ping'
require 'rss/2.0'
require 'time'

class HtmlRss

  def self.proxy()
    oracle_proxy = 'www-proxy.us.oracle.com'
    Ping.pingecho(oracle_proxy, 5, 80) ? "http://#{oracle_proxy}" : nil
  end


  def self.load_rss(uri)
    
    rss = RSS::Rss.new('2.0')
	
    rss.channel = RSS::Rss::Channel.new
    rss.channel.title = "#{uri}"
    rss.channel.link = uri
    rss.channel.generator = 'webwatch.rb'
    rss.channel.description = "WebWatch feed generated for: #{uri} at #{Time.now}"
    
    item = RSS::Rss::Channel::Item.new
    item.link = uri
    time = content = title = nil
    begin
      open(uri, :proxy=>proxy()) do |f|
      content = f.read
      title = /<title>(.*?)<\/title>/im.match(content)[1] || uri
      # TODO really should track time based on change to checksum for sites without last_modified header ?
      time = f.last_modified || Time.now
    end
    rescue Exception => e
      content = "<pre>#{e}</pre>"
      title = "Error reading #{uri}"
      time = Time.now
    end
    t = time.strftime('%a, %d %b %Y %H:%M:%S %Z')
    item.title = "#{title} [#{uri}, updated #{t}]"
    item.pubDate = t
    item.description = "<![CDATA[<base href=\"#{uri}\">\n#{content}]]>\n"

    rss.channel.items << item
	
    rss
  end
end

uri = ARGV[0].chomp
puts HtmlRss.load_rss( uri )
