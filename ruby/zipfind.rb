#!/usr/bin/env ruby

# grep for something (filename) in a zipinfo

require 'rubygems'
require 'pathname'
require 'zip/zip'

ZIP = /\.(zip|jar|ear|war)$/

# first args are where to search (default is .)
# last arg is pattern

pat = ARGV.delete_at(-1)
pat = pat.nil? ? /./ : Regexp.new(pat)

where = ARGV.length == 0 ? ['.'] : ARGV

where.each do |d|
  Pathname.new(d).find do |f|
    next if f.directory? || f.extname !~ ZIP
    begin
      Zip::ZipFile.foreach(f) { |z| puts "#{f}: #{z}" if z.file? && z.name =~ pat }
    rescue
      puts "Error reading zip #{f}, skipping: #{$!}"
    end
  end
end
