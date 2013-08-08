#!/usr/bin/env ruby
require 'cgi'
ARGF.each { |line|  print CGI::escapeHTML(line) }
