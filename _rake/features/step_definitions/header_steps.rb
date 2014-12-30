When(/^I click header navigation link text "(.*?)"$/) do |link_text|
	@driver.find_element(:xpath, ".//*[@class='nav-global']//a[text()='#{link_text}']").click
end

When(/^I click header's search (button|link)$/) do |target|
	if target == 'button'
		@page.header.search_button.click
	end
	if target == 'link'
		@page.header.search_link.click
	end
end

Then(/^I should see that header's logo link has text "(.*?)"$/) do |logo_text|
	assert_equal(logo_text, @page.header.logo_link.text)
end

Then(/^I should have clickable header's logo link$/) do
	assert_equal(true, is_link_clickable(@page.header.logo_link))
end

Then(/^I should have header's navigation links presented$/) do
	assert_equal(NAV_LINKS.count, @page.header.nav_links.count)

	@page.header.nav_links.each do |link|
		assert_equal(true, NAV_LINKS.include?(link.attribute('textContent')))
	end
end

Then(/^I should (not see|see) header's navigation links$/) do |target|
	if target == 'see'
		@page.header.nav_links.each do |link|
			assert_equal(false, link.text.empty?)

			assert_equal(true, link.displayed?)
			assert_equal(true, link.enabled?)
			assert_equal(true, link.attribute('href').end_with?(link.text.downcase))
		end
	end
	if target == 'not see'
		@page.header.nav_links.each do |link|
			assert_equal(false, link.displayed?)
			assert_equal(true, link.text.empty?)
		end
	end
end

Then(/^I should have clickable header's navigation links$/) do
	assert_equal(true, @page.header.nav_links.count > 0)

	@page.header.nav_links.each do |link|
		assert_equal(true, is_link_clickable(link))
	end
end

Then(/^I should (not see|see) header's search link$/) do |target|
	if target == 'see'
		assert_equal(true, @page.header.search_link.displayed?)
	end
	if target == 'not see'
		assert_equal(false, @page.header.search_link.displayed?)
	end
end

Then(/^I should (not see|see) header's menu and search button$/) do |target|
	if target == 'see'
		assert_equal(true, @page.header.search_menu.displayed?)
		assert_equal(true, @page.header.search_button.displayed?)
	end
	if target == 'not see'
		assert_equal(false, @page.header.search_menu.displayed?)
		assert_equal(false, @page.header.search_button.displayed?)
	end
end

Then(/^I should have clickable header's search (button|link)$/) do |target|
	if target == 'button'
		assert_equal(true, is_element_clickable(@page.header.search_button))
	end
	if target == 'link'
		assert_equal(true, is_link_clickable(@page.header.search_link))
	end
end