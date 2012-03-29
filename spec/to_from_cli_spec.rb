#!/usr/bin/env ruby

require 'rubygems'
require 'rspec'
require 'rspec/matchers'
require 'to_from'

DIR = File.expand_path(File.dirname(__FILE__) + '/../bin')
TEST_DIR = File.dirname(__FILE__) + '/fixture_dir/test'

describe "The to_from executable" do
  it 'finds the easy js spec file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a.js}.
      chomp.should == (TEST_DIR + '/spec/a_spec.js')
    $?.should == 0
  end

  it 'finds the easy js source file when forced' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec --find-src a.js}.
      chomp.should == (TEST_DIR + '/src/a.js')
    $?.should == 0
  end

  it 'finds the easy js spec file when forced' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec --find-spec a_spec.js}.
      chomp.should == (TEST_DIR + '/spec/a_spec.js')
    $?.should == 0
  end

  it 'finds the easy js source file' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_spec.js}.
      chomp.should == (TEST_DIR + '/src/a.js')
    $?.should == 0
  end

  it 'finds the difficult spec' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' nested.rb}.
      chomp.should == (TEST_DIR + '/spec/dir1/dir2/dir3/nested_spec.rb')
    $?.should == 0
  end

  it 'finds duplicate matches' do
    lines = %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' duplicate.rb}.chomp.split("\n")
    lines[0].should == (TEST_DIR + '/spec/dir1/duplicate_spec.rb')
    lines[1].should == (TEST_DIR + '/spec/duplicate_spec.rb')
    lines.size.should == 2
    $?.should == 0
  end

  it 'exits non-zero for a failed match' do
    %x{#{DIR}/to_from.rb --src-dir '#{TEST_DIR}/src' --spec-dir '#{TEST_DIR}/spec' --file-ext .js --spec-suffix _spec a_fake_spec.js}.
      chomp.should == ''
    $?.should_not == 0
  end
end

