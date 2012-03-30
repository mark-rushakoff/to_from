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

class ToFrom
  def initialize(dir_suffix_map=nil)
    @map = dir_suffix_map || {}
  end

  def matching_suffix(name)
    suffixes = @map.values.uniq.sort_by { |v| -(v.length) }
    suffixes.detect { |s| name.end_with? s }
  end

  def root_name(name)
    suffix = matching_suffix(name)
    raise 'No suffix found' unless suffix
    name.chomp suffix
  end
end

def to_from(opts)
  raise 'No file specified' unless opts[:name]

  v = opts[:verbose]

  $stderr.puts('Input: ' + opts[:name]) if v

  src_ext = opts[:file_ext]
  src_matcher = src_ext + '$'
  spec_ext = opts[:spec_suffix] + src_ext
  spec_matcher = spec_ext + '$'

  is_spec = opts[:name].match(spec_matcher)
  $stderr.puts("Appears to be a spec file? #{not not is_spec}") if v

  if is_spec
    old_ext = spec_ext
    new_ext = src_ext
    dir = opts[:src_dir]
  else
    old_ext = src_ext
    new_ext = spec_ext
    dir = opts[:spec_dir]
  end

  complement = opts[:name][0...(-(old_ext.size))] + new_ext
  $stderr.puts("Complementary file: #{complement}") if v

  if (opts[:find_spec] and is_spec)
    target = opts[:name]
    dir = opts[:spec_dir]
  elsif (opts[:find_src] and not is_spec)
    target = opts[:name]
    dir = opts[:src_dir]
  else
    target = complement
  end

  $stderr.puts("Searching for #{target} in #{dir}") if v

  glob_pattern = dir + '/**/' + target
  $stderr.puts("Glob pattern: #{glob_pattern}") if v
  globbed = Dir.glob(glob_pattern).sort
  if globbed.size == 0
    $stderr.puts("No matching file(s) found for #{glob_pattern}")
  elsif globbed.size > 1
    $stderr.puts("Warning: Multiple files matched!")
  end
  globbed
end
