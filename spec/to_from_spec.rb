#!/usr/bin/env ruby

require 'rubygems'
require 'minitest/autorun'
require 'to_from'

describe ToFrom do
  describe 'initializing with options' do
      %w(file_ext src_dir spec_dir spec_suffix ).each do |opt|
        it('works for ' + opt) do
          obj = { :foo => 'bar' }
          opts = {}
          opts[opt.to_sym] = obj
          tf = ToFrom.new('tf', opts)
          val = tf.send opt.to_sym
          val.must_equal obj
        end
      end
  end
end
