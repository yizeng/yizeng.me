module Pages
	class Header

		def initialize(driver)
			@header = driver.find_element(:css => '#page > header')
		end

		def element
			@header
		end

		def logo_link
			@header.find_element(:css => '.logo > a')
		end

		def search_menu
			@header.find_element(:css => 'button.btn-menu')
		end

		def search_button
			@header.find_element(:css => 'button.btn-search')
		end

		def nav_links
			@header.find_elements(:css => ".nav-link:not(.logo) > a[href^='/']")
		end

		def search_link
			@header.find_element(:css => 'a.btn-search')
		end
	end
end