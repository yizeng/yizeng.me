module Pages
	class HomePage

		def initialize(driver)
			@driver = driver
		end

		def navigation_circles
			return @driver.find_elements(:css => '#fullPage-nav a')
		end

# Region: Section Bio
		def section_bio
			return @driver.find_element(:id => 'section0')
		end

		def header_name
			return section_bio.find_element(:tag_name => 'h1')
		end

		def header_title
			return section_bio.find_element(:tag_name => 'h2')
		end

		def header_location
			return section_bio.find_element(:tag_name => 'h3')
		end

		def btn_continue
			return section_bio.find_element(:class => 'btn-continue')
		end
# EndRegion

# Region: Section Social
		def section_social
			return @driver.find_element(:id => 'section1')
		end

		def btn_enter_blog
			return section_social.find_element(:css => 'h1 > a')
		end

		def social_links
			return section_social.find_elements(:css => '.social-links > a')
		end
# EndRegion
	end
end