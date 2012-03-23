#!/usr/bin/env ruby

require 'rubygems'
require 'minitest/autorun'
require 'to_from'

DIR = File.dirname(__FILE__)
TEST_DIR = DIR + '/test'

describe :to_from do
  it 'finds the easy js spec file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a.js}.
      chomp.must_equal(TEST_DIR + '/spec/a_spec.js')
    $?.must_equal 0
  end

  it 'finds the easy js source file when forced' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec --find-src a.js}.
      chomp.must_equal(TEST_DIR + '/src/a.js')
    $?.must_equal 0
  end

  it 'finds the easy js spec file when forced' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec --find-spec a_spec.js}.
      chomp.must_equal(TEST_DIR + '/spec/a_spec.js')
    $?.must_equal 0
  end

  it 'finds the easy js source file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_spec.js}.
      chomp.must_equal(TEST_DIR + '/src/a.js')
    $?.must_equal 0
  end

  it 'finds the difficult spec' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' nested.rb}.
      chomp.must_equal(TEST_DIR + '/spec/dir1/dir2/dir3/nested_spec.rb')
    $?.must_equal 0
  end

  it 'exits non-zero for a failed match' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_fake_spec.js}.
      chomp.must_equal('')
    $?.wont_equal 0
  end
end

