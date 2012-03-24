#!/usr/bin/env ruby
#
# https://github.com/mark-rushakoff/to_from
#
# MIT LICENSE
#
# Copyright (c) 2012 Mark Rushakoff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require File.expand_path(File.dirname(__FILE__) + '/../lib/to_from')
require 'rubygems'
require 'trollop'

opts = Trollop::options do
  opt :src_dir, 'Source directory', :default => './src'
  opt :spec_dir, 'Spec directory', :default => './spec'
  opt :file_ext, 'File extension', :default => '.rb'
  opt :spec_suffix, 'Spec suffix (before .file_extension)', :default => '_spec'
  opt :name, 'Explicitly set name of file'
  opt :find_spec, 'Force return of spec file (may be same as input)', :default => false
  opt :find_src, 'Force return of source file (may be same as input)', :default => false
  opt :verbose, 'Verbose output', :default => false
end

opts[:name] ||= ARGV[0]
match = to_from(opts)

match.each do |file|
  puts file
end

exit match.size > 0 ? 0 : 1
