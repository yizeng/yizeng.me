When(/^I search for "(.*?)"$/) do |query|
	@page.search_overlay.input.send_keys(query)
end

When(/^I close search overlay using 'Close' button$/) do
	@page.search_overlay.btn_close.click
end

Then(/^I should have search overlay opened$/) do
	assert_equal(true, is_element_clickable(@page.search_overlay.element))
	assert_equal(true, is_element_clickable(@page.search_overlay.input))
	assert_equal(true, is_element_clickable(@page.search_overlay.btn_close))

	assert_equal(0, @page.search_overlay.results.count)
	assert_equal(0, @page.search_overlay.result_dates.count)
end

Then(/^I should have search overlay closed$/) do
	assert_equal(false, is_element_clickable(@page.search_overlay.element))
	assert_equal(false, is_element_clickable(@page.search_overlay.input))
	assert_equal(false, is_element_clickable(@page.search_overlay.btn_close))

	@page.search_overlay.results.each do |result|
		assert_equal(false, is_element_clickable(result))
	end
end

Then(/^I should see (posts|no posts) are found$/) do |target|
	if target == 'posts'
		assert_equal(true, @page.search_overlay.results.count > 0)

		@page.search_overlay.results.each do |result|
			assert_equal(true, is_element_clickable(result))
		end
	end
	if target == 'no posts'
		assert_equal(0, @page.search_overlay.results.count)
		assert_equal(0, @page.search_overlay.result_dates.count)
	end
end

Then(/^I should (see|not see) date in result list$/) do |target|
	if target == 'see'
		@page.search_overlay.result_dates.each do |date|
			assert_equal(true, date.displayed?)
			assert_equal(false, date.text.empty?)
		end
	end
	if target == 'not see'
		@page.search_overlay.result_dates.each do |date|
			assert_equal(false, date.displayed?)
		end
	end
end

