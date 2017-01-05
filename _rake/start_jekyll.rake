desc 'Start Jekyll locally'
task :jekyll do
  puts 'Usage: rake jekyll [port=4000]'

  port = ENV['port'] || '4000'
  trace = ENV['trace'] == 'true' ? '--trace' : ''

  # Set active code page to avoid encoding issues on Windows
  platforms = %w(mswin mingw32)
  if platforms.any? { |platform| RUBY_PLATFORM.downcase.include? platform }
    system 'chcp 65001'
  end

  system "bundle exec jekyll serve --watch --drafts --trace --port=#{port}"
  sleep 3
end

desc 'Start Jekyll on Travis CI'
task :travis do
  system 'bundle exec jekyll serve --detach --trace'
  sleep 3
end
