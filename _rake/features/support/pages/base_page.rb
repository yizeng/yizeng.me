require './_rake/features/support/pages/footer.rb'
require './_rake/features/support/pages/header.rb'

module Pages
	class BasePage

		def initialize(driver)
			@driver = driver
		end

		def header
			return Pages::Header.new(@driver)
		end

		def body_content
			return @driver.find_element(:css => '.body .content')
		end

		def title_header
			return body_content.find_element(:css => 'header .entry-title')
		end

		def footer
			return Pages::Footer.new(@driver)
		end

		def search_overlay
			return Pages::SearchOverlay.new(@driver)
		end
	end
end