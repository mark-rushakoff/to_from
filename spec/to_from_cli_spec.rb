#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.require(:development)

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
ENV['RUBYLIB'] = File.dirname(__FILE__) + '/../lib'

shared_examples_for 'using options' do |option_description|
  def get_output(args, exit_code=0)
    Dir.chdir(FIXTURE_DIR) do
      lines = %x{#{BIN} #{extra_options} #{args}}.lines.map(&:chomp)
      $?.exitstatus.should == exit_code
      lines
    end
  end

  def assert_root_file_output(lines)
    lines.length.should == expected_num_lines
    lines.should include 'src/root_file.src'
    lines.should include 'spec/root_file_spec.src'
    lines.should include 'templates/root_file.template' if searches_template?
  end

  def assert_foo_output(lines)
    lines.length.should == expected_num_lines
    lines.should include 'src/nested/foo.src'
    lines.should include 'spec/nested/foo_spec.src'
    lines.should include 'templates/nested/foo.template' if searches_template?
  end

  describe "when using #{option_description}" do
    it 'assumes a rooted name by default' do
      assert_root_file_output(get_output('root_file'))
    end

    it 'assumes a rooted name by default and can find nested results' do
      assert_foo_output(get_output('foo'))
    end

    it 'returns 0 and has no output if no matches are found' do
      lines = get_output('asdf')
      lines.should be_empty
    end

    describe 'the -r option' do
      it 'restricts results to a single directory' do
        lines = get_output('-r src root_file')
        lines.should == ['src/root_file.src']
      end

      it 'can be passed multiple times' do
        lines = get_output('-r src -r spec root_file')
        lines.length.should == 2
        lines.should include 'src/root_file.src'
        lines.should include 'spec/root_file_spec.src'
      end
    end

    describe 'the -x option' do
      it 'excludes results from the specified directory' do
        lines = get_output('-x spec root_file')
        lines.length.should == (expected_num_lines - 1)
        lines.should include 'src/root_file.src'
        lines.should include 'templates/root_file.template' if searches_template?
      end

      it 'can be passed multiple times' do
        lines = get_output('-x src -x spec root_file')
        lines.length.should == (expected_num_lines - 2)
        lines.should include 'templates/root_file.template' if searches_template?
      end
    end

    it 'accepts the -s option to indicate a suffix is present on the supplied option' do
      assert_foo_output(get_output('-s foo.src'))
      assert_foo_output(get_output('-s foo_spec.src'))
      assert_foo_output(get_output('-s foo.template')) if searches_template?

      assert_root_file_output(get_output('-s root_file.src'))
      assert_root_file_output(get_output('-s root_file_spec.src'))
      assert_root_file_output(get_output('-s root_file.template')) if searches_template?
    end

    it 'returns 1 if a suffix is specified but indeterminable' do
      get_output('-s test.no.match.suffix', 1)
    end
  end
end

describe 'The to_from executable' do
  it_behaves_like('using options', 'the default config file') do
    let(:extra_options) { '' }
    let(:expected_num_lines) { 3 }
    let(:searches_template?) { true }
  end

  it_behaves_like('using options', 'a custom config file') do
    let(:extra_options) { '-c alt_config_file' }
    let(:expected_num_lines) { 2 }
    let(:searches_template?) { false }
  end

  it 'returns 1 when an invalid config file is specified' do
    %x{#{BIN} -c test.no.match.config baz}
    $?.exitstatus.should == 1
  end
end
