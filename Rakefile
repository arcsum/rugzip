require 'rake'
require 'rake/testtask'

task default: :test

desc 'Open an irb session preloaded with this library.'
task :console do
  sh 'irb -I lib/ -r rugzip'
end

Rake::TestTask.new do |task|
  task.libs << 'spec'
  task.test_files = FileList['spec/**/*_spec.rb']
end
