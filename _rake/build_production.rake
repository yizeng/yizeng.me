require 'fileutils'

namespace :build do

	desc 'Build main site into to a pre-defined submodule that will be published to GitHub'
	task :en do
		ProductionBuilder.new('./yizeng.github.io', 'yizeng.me').build
	end

	desc "Build Chinese site into to a pre-defined folder that will be published to GitHub"
	task :cn do
		ProductionBuilder.new('../cn.yizeng.me-gh-pages', 'cn.yizeng.me').build
	end

	class ProductionBuilder
		def initialize(production_dir, cname)
			@production_dir = production_dir
			@cname = cname
		end

		def build
			cleanup_production()
			compile_compass(compressed: true)
			build_jekyll()

			create_production()
			compress_source()

			# re-compile Compass without compressing for development
			compile_compass(compressed: false)
		end

		def execute_command(command)
			puts "#{command}"
			puts `#{command}`

			exit 1 unless $?.success?
		end

		def cleanup_production
			FileUtils.rm_rf("./_site", :verbose => true)
			FileUtils.rm_rf(Dir.glob("#{@production_dir}/*"), :verbose => true)
		end

		def compile_compass(options = {:compressed => true})
			output_style = options[:compressed] ? 'compressed' : 'expanded'
			execute_command("compass compile ./assets/css --no-line-comments --trace --force --output-style=#{output_style}")
		end

		def build_jekyll
			execute_command "jekyll build"
		end

		def create_production
			# remove unnecessary compass files
			FileUtils.rm_rf("./_site/assets/css/sass", :verbose => true)
			FileUtils.rm_f("./_site/assets/css/config.rb", :verbose => true)

			# copy _site to production
			FileUtils.cp_r(Dir.glob("./_site/*"), "#{@production_dir}/", :verbose => true)

			# create and copy necessary files to production
			File.open("#{@production_dir}/CNAME", 'w+') {|f| f.write(@cname) }
			FileUtils.touch("#{@production_dir}/.nojekyll", :verbose => true)
			FileUtils.cp('.gitignore', "#{@production_dir}/", :verbose => true)
		end

		def compress_source
			Dir.glob("#{@production_dir}/**/*.html") do |html_file|
				execute_command "java -jar ./_rake/tools/htmlcompressor-1.5.3.jar --recursive --compress-js -o #{html_file} #{html_file}"
			end
		end
	end
end