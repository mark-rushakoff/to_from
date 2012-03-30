#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup(:spec)
require 'rspec'

=begin
  $ tree --charset=ascii -F fixture_dir/
  fixture_dir/
  |-- alt_config_file
  |-- spec/
  |   |-- nested/
  |   |   `-- foo_spec.src
  |   `-- root_file_spec.src
  |-- src/
  |   |-- nested/
  |   |   `-- foo.src
  |   `-- root_file.src
  `-- templates/
  |   |-- nested/
  |   |   `-- foo.template
  |   `-- root_file.template
  `-- to_from.config.yml
=end

BIN = File.dirname(__FILE__) + '/../bin/to_from'
FIXTURE_DIR = File.dirname(__FILE__) + '/fixture_dir'

Dir.chdir(FIXTURE_DIR) do

def get_output(args)
  %x{#{BIN} #{args}}.lines.map(&:chomp)
end

def assert_root_file_output(lines)
  lines.length.should == 3
  lines.should include 'src/root_file.src'
  lines.should include 'spec/root_file_spec.src'
  lines.should include 'templates/root_file.template'
end

def assert_foo_output(lines)
  lines.length.should == 3
  lines.should include 'src/nested/foo.src'
  lines.should include 'spec/nested/foo_spec.src'
  lines.should include 'templates/nested/foo.template'
end

describe "The to_from executable" do
  it 'uses to_from.config.yml and assumes a rooted name by default' do
    lines = get_output('root_file')
    assert_root_file_output(lines)
  end

  it 'uses to_from.config.yml and assumes a rooted name by default and finds nested results' do
    lines = get_output('foo')
    assert_foo_output(lines)
  end

  it 'accepts the -s option to indicate a suffix is present on the supplied option' do
    assert_foo_output(get_output('-s foo.src'))
    assert_foo_output(get_output('-s foo_spec.src'))
    assert_foo_output(get_output('-s foo.template'))

    assert_root_file_output(get_output('-s root_file.src'))
    assert_root_file_output(get_output('-s root_file_spec.src'))
    assert_root_file_output(get_output('-s root_file.template'))
  end
end

end # chdir
