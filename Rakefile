require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :prog do
  namespace :members do
    desc "run Prog::Members::Syncopator script"
    task :sync do
      system "./bin/sync"
    end
  end
end

task :default => :test
