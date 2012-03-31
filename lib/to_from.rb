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
    return name.chomp suffix if name.end_with? suffix
  end

  def find_match_in_dir(rooted_name, dir)
    glob = "#{dir}/**/#{rooted_name}#{@map[dir]}"
    Dir.glob(glob)
  end

  def find_all_matches(rooted_name)
    @map.keys.map do |dir|
      find_match_in_dir(rooted_name, dir)
    end.flatten
  end
end
