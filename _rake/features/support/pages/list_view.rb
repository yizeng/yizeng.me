require './_rake/features/support/pages/base_page.rb'

module Pages
	class ListView < BasePage
		def posts
			return body_content.find_elements(:class => 'posts')
		end
	end
end