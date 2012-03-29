#!/usr/bin/env rake

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  # don't recurse in and find the fake specs
  t.pattern = 'spec/*_spec.rb'
end

task :default => :spec
