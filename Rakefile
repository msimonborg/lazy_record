# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'yardstick/rake/measurement'

Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = 'measurement/report.txt'
end

require 'yardstick/rake/verify'

Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 49.2
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %i[spec rubocop verify_measurements]
