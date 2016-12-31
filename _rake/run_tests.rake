require 'rake/testtask'

namespace :test do
  desc 'Run Ruby test-unit tests for sample code used in posts'
  task posts: [:test]
  Rake::TestTask.new(:test) do |test|
    test.libs << 'test'
    test.test_files = FileList['./_tests/posts/*test.rb']
    test.verbose = true
  end
end
