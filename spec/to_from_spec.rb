#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup(:spec)
require 'rspec'
require 'fakefs/spec_helpers'
require 'to_from'

describe ToFrom do
  before(:each) do
    opts = {
      'src' => '.src',
      'spec' => '_spec.src',
      'templates' => '.template'
    }

    @tf = ToFrom.new(opts)
  end

  describe :matching_suffix do
    it 'returns the matching suffix when one exists' do
      @tf.matching_suffix('a.src').should == '.src'
      @tf.matching_suffix('baz_spec.src').should == '_spec.src'
      @tf.matching_suffix('quux.template').should == '.template'
    end

    it 'returns nil when no matching suffix exists' do
      @tf.matching_suffix('foo').should be_nil
      @tf.matching_suffix('foo_src').should be_nil
    end
  end

  describe :root_name do
    it 'returns the root name when a matching suffix exists' do
      @tf.root_name('foo.src').should == 'foo'
      @tf.root_name('bar_spec.src').should == 'bar'
      @tf.root_name('baz.template').should == 'baz'
    end

    it 'returns nil if no matching suffix is found' do
      @tf.root_name('foo').should be_nil
    end
  end

  describe :find_match_in_dir do
    include FakeFS::SpecHelpers
    before(:each) do
      @tf.base_dir = '.'
    end

    it 'returns an empty array when no match is found under dir' do
      @tf.find_match_in_dir('foo', 'src').should be_empty
    end

    it 'returns an array containing only the one matching item' do
      Dir.mkdir 'src'
      FileUtils.touch('src/foo.src')

      @tf.find_match_in_dir('foo', 'src').should == ['src/foo.src']
    end

    it 'returns an array containing more than one matching item' do
      FileUtils.mkdir_p 'src/bar'
      FileUtils.touch('src/foo.src')
      FileUtils.touch('src/bar/foo.src')

      matches = @tf.find_match_in_dir('foo', 'src')
      matches.length.should == 2
      matches.should include 'src/foo.src'
      matches.should include 'src/bar/foo.src'
    end
  end
end
