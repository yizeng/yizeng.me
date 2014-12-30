require 'rake/testtask'

namespace :test do
	desc "Run Cucumber Selenium WebDriver UI tests"
	task :ui do
		browser = ENV['browser'].nil? ? '' : 'browser=' + ENV['browser']
		system "cucumber ./_rake/features/ #{browser}"
		raise "Cucumber tests failed!" unless $?.exitstatus == 0
	end

	desc "Run Ruby test-unit tests for sample code used in posts"
	task :posts => [:test]
	Rake::TestTask.new(:test) do |test|
		test.libs << 'test'
		test.test_files = FileList['./_rake/test/*test.rb']
		test.verbose = true
	end
end