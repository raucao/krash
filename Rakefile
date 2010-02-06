require 'rubygems'
require 'cucumber/rake/task'
require 'spec/rake/spectask'

task :default => ['rake:spec', 'rake:features']

desc "Runs the Cucumber Features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

namespace :features do

  desc "Runs the @current features or scenarios"
  Cucumber::Rake::Task.new(:current) do |c|
    c.cucumber_opts = "--format pretty -t current"
  end

end

desc "Runs the RSpec Test Suite"
Spec::Rake::SpecTask.new(:spec) do |r|
  r.spec_files = FileList.new('spec/*_spec.rb', 'spec/**/*_spec.rb')
  r.spec_opts = ['--color']
end
