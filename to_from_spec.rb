#!/usr/bin/env ruby

require 'rubygems'
require 'minitest/autorun'
require 'to_from'

DIR = File.dirname(__FILE__)
TEST_DIR = DIR + '/test'

describe :to_from do
  it 'finds the easy js spec file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a.js}.
      chomp.must_equal TEST_DIR + '/spec/a_spec.js'
    $?.must_equal 0
  end

  it 'finds the easy js source file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_spec.js}.
      chomp.must_equal TEST_DIR + '/src/a.js'
    $?.must_equal 0
  end

  it 'exits non-zero for a failed match' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_fake_spec.js}.
      chomp.must_equal ''
    $?.to_i.wont_equal 0
  end
end

