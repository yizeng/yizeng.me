module Pages
	class Footer

		def initialize(driver)
			@footer = driver.find_element(:css => '#page > footer')
		end

		def element
			@footer
		end

		def about_link
			@footer.find_element(:css => 'h4 > a')
		end

		def social_links
			@footer.find_elements(:css => ".social-links > a")
		end

		def find_social_link(title)
			return @footer.find_element(:xpath => ".//a[contains(@title, '#{title}')]")
		end
	end
end