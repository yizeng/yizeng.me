desc "Start Jekyll locally"
task :jekyll do
	puts 'Usage: rake jekyll [port=4000]'

	port = ENV['port'] || '4000'
	trace = ENV['trace'] == 'true' ? '--trace' : ''

	# Set active code page to avoid encoding issues on Windows
	platforms = %w[mswin mingw32]
	if platforms.any? { |platform| RUBY_PLATFORM.downcase.include? platform }
		system 'chcp 65001'
	end

	system "compass compile ./assets/css"
	system "jekyll serve --watch --drafts --trace --port=#{port}"
	sleep 3
end

desc "Start Compass watching"
task :compass do
	puts 'Usage: rake compass'

	system "compass watch ./assets/css"
end

desc "Start Jekyll on Travis CI"
task :travis do
	puts 'Usage: rake travis'

	system "compass compile ./assets/css"

	system "jekyll serve --detach --trace"
	exit 1 unless $?.success?

	sleep 3
end
