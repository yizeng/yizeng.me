module Pages
	class SearchOverlay

		def initialize(driver)
			@overlay = driver.find_element(:class => 'search-wrapper')
		end

		def element
			@overlay
		end

		def input
			@overlay.find_element(:class => 'search-field')
		end

		def btn_close
			@overlay.find_element(:class => 'btn-close')
		end

		def result_list
			@overlay.find_element(:class => 'results')
		end

		def results
			@overlay.find_elements(:css => '.results > li > a')
		end

		def result_dates
			@overlay.find_elements(:css => '.results .entry-date > time')
		end
	end
end