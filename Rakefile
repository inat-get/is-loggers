# Rakefile

require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files = [ 'lib/**/*.rb', 'README.md' ]
  t.options = [ '--output-dir', 'doc', '--readme', 'README.md' ]
end

task default: [:spec, :yard]
task docs: :yard
