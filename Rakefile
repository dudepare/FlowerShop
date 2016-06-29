require 'rake/testtask'
require 'roodi'
require 'roodi_task'

Rake::TestTask.new do |task|
  task.libs << %w(spec)
  task.pattern = 'spec/*_test.rb'
end

RoodiTask.new

task :default => [:test, :roodi]

