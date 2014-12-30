require './_rake/features/support/pages/list_view.rb'

module Pages
	class BlogPage < ListView

		def initialize(driver)
			super(driver)
		end

		def list_year_headers
			return body_content.find_elements(:class => 'year')
		end
	end
end