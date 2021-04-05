require 'fileutils'
require 'rake/testtask'

class ProductionBuilder
  def initialize(production_dir, cname)
    @production_dir = production_dir
    @cname = cname
  end

  def build
    cleanup_production
    build_jekyll

    create_production
    compress_source
  end

  def execute_command(command)
    puts command.to_s
    puts `#{command}`
  end

  def cleanup_production
    FileUtils.rm_rf('./_site', verbose: true)
    FileUtils.rm_rf(Dir.glob("#{@production_dir}/*"), verbose: true)
  end

  def build_jekyll
    execute_command 'bundle exec jekyll build JEKYLL_ENV=production --safe'
  end

  def create_production
    # Copy _site to production
    FileUtils.cp_r(Dir.glob('./_site/*'), "#{@production_dir}/", verbose: true)

    # Create and copy necessary files to production
    File.open("#{@production_dir}/CNAME", 'w+') { |f| f.write(@cname) }
    FileUtils.touch("#{@production_dir}/.nojekyll", verbose: true)
  end

  def compress_source
    Dir.glob("#{@production_dir}/**/*.html") do |html_file|
      execute_command "java -jar ./_rake/tools/htmlcompressor-1.5.3.jar --recursive --compress-js -o #{html_file} #{html_file}"
    end
  end
end

desc 'Start Jekyll locally'
task :jekyll do
  port = ENV['PORT'] || '4000'
  drafts = ENV['DRAFTS'] == 'true' ? '--drafts' : ''
  trace = ENV['TRACE'] == 'true' ? '--trace' : ''

  puts "Usage: rake jekyll [port=#{port}]"

  # Set active code page to avoid encoding issues on Windows
  platforms = %w(mswin mingw32)
  if platforms.any? { |platform| RUBY_PLATFORM.downcase.include? platform }
    system 'chcp 65001'
  end

  system "bundle exec jekyll serve --incremental --livereload --safe #{drafts} #{trace} --port=#{port}"
  sleep 3
end

desc 'Start Jekyll on Travis CI'
task :travis do
  system 'bundle exec jekyll serve --detach --trace'
  sleep 3
end

desc 'Build main site into to docs folder that will be published to GitHub'
task :build do
  ProductionBuilder.new('./docs', 'yizeng.me').build
end

namespace :test do
  desc 'Run Ruby test-unit tests for sample code used in posts'
  task posts: [:test]
  Rake::TestTask.new(:test) do |test|
    test.libs << 'test'
    test.test_files = FileList['./_tests/posts/*test.rb']
    test.verbose = true
  end
end
