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

  describe :matching_suffix do
    it 'works' do
      @tf.matching_suffix('a.src').should == '.src'
      @tf.matching_suffix('baz_spec.src').should == '_spec.src'
      @tf.matching_suffix('quux.template').should == '.template'

      @tf.matching_suffix('foo').should be_nil
      @tf.matching_suffix('foo_src').should be_nil
    end
  end

  describe :root_name do
    it 'works' do
      @tf.root_name('foo.src').should == 'foo'
      @tf.root_name('bar_spec.src').should == 'bar'
      @tf.root_name('baz.template').should == 'baz'
    end
  end
end
