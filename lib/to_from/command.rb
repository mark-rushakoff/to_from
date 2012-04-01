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

require 'rubygems'
require 'bundler'
Bundler.setup(:default)

require 'to_from'
require 'clip'
require 'yaml'

module ToFrom
  class Command
    def self.main
      options = Clip do |p|
        p.optional('c', 'config', :desc => 'config file', :default => 'to_from.config.yml')
        p.optional('r', 'restrict', :desc => 'restrict directory to search (can be passed multiple times)', :multi => true)
        p.optional('x', 'exclude', :desc => 'exclude a directory from search (can be passed multiple times)', :multi => true)
        p.flag('s', 'suffix', :desc => 'indicate that NAME has a suffix')
      end

      abort('Cannot specify both restrict and exclude options') if options.restrict && options.exclude

      if options.valid? && !options.remainder.empty?
        config_file = options.config
        abort("Cannot open configuration file #{config_file}") unless File.readable?(config_file)
        hashes = YAML::load(File.open(config_file))
        dir_suffixes = {}
        hashes.each do |hash|
          dir_suffixes[hash['dir']] = hash['suffix']
        end

        tf = ToFrom.new(dir_suffixes)

        name = options.remainder[0]
        root_name = (options.suffix? ? tf.root_name(name) : name)

        abort('Could not find appropriate suffix for ' + name) unless root_name

        if options.restrict
          options.restrict.each do |dir|
            puts tf.find_match_in_dir(root_name, dir)
          end
        elsif options.exclude
          (dir_suffixes.keys - options.exclude).each do |dir|
            puts tf.find_match_in_dir(root_name, dir)
          end
        else
          puts tf.find_all_matches(root_name)
        end
      else
        abort(options.to_s)
      end
    end
  end
end
