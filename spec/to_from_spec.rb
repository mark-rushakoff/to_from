#!/usr/bin/env ruby

require 'rubygems'
require 'rspec'
require 'to_from'

describe ToFrom do
  before(:each) do
    opts = {}
    opts['src'] = '.src'
    opts['spec'] = '_spec.src'
    opts['templates'] = '.template'

    @tf = ToFrom.new(opts)
  end

  describe :root_name do
    pending 'works' do
      @tf.root_name('foo.src').should == 'foo'
      @tf.root_name('bar_spec.src').should == 'bar'
      @tf.root_name('baz.template').should == 'baz'
    end
  end

  describe :find_all_matches do
    pending 'globs the right directories' do
      Dir.stub(:glob)
      tf.find_all_matches('foo.src')
      Dir.should_receive(:glob).with('src/**/foo.src')
      Dir.should_receive(:glob).with('spec/**/foo_spec.src')
      Dir.should_receive(:glob).with('templates/**/foo.template')
    end
  end
end
