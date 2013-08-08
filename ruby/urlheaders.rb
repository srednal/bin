#!/usr/bin/env ruby

# Print headers from a URL GET.
# This is useful for seeing the server version, checking cookies, and other
# debugging tasks.
# Usage:  urlheaders http://the.url.com/page.html
#
# author Dave Landers

require 'urldump'

dump ARGV[0], true, false
