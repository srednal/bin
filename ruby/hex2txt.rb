#!/usr/bin/env ruby

$stdin.each{ |l| puts l.split.collect{ |b| b.hex }.collect{ |n| n < 32 || n > 126 ? '.' : n.chr }.join }

