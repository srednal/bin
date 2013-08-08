#!/usr/bin/env ruby

# Print headers and body from a URL GET.
# This is useful for seeing the server version, checking cookies, and other
# debugging tasks.
# Usage:  urldump http://the.url.com/page.html
#
# author Dave Landers

require 'open-uri'

USAGE ="\nUsage: #{$0} url\n"

def dump( arg, do_head=false, do_body=true )
  raise USAGE unless arg

  uri = URI.parse ARGV[0]
  # fix uri with http if not given in args
  uri = URI.parse( 'http://' + ARGV[0] ) unless uri.scheme

  open( uri ) do |f|
    puts '-------------------- HEAD --------------------' if do_head && do_body    
    puts f.status.join(' ')                               if do_head
    f.meta.each_pair{ |k,v| puts "#{k}: #{v}" }           if do_head
    puts '-------------------- BODY --------------------' if do_head && do_body
    puts f.readlines                                      if do_body
  end
end


if __FILE__ == $0
  dump ARGV[0]
end
