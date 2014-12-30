Given(/^I visit "(home|blog|archives|categories|tags|about)" page$/) do |page_name|
	url = SITE_URL
	case page_name
		when 'home'
			url += '/'
			@page = Pages::HomePage.new(@driver)
		when 'blog'
			url += '/blog'
			@page = Pages::BlogPage.new(@driver)
		when 'archives'
			url += '/archives'
		when 'categories'
			url += '/categories'
		when 'tags'
			url += '/tags'
		when 'about'
			url += '/about'
	end
	@driver.navigate.to(url)
end

Given(/^I set window width to (\d+)px$/) do |window_width|
	@driver.manage.window.resize_to(window_width, WINDOW_HEIGHT)
end

Given(/^I set window width to (\d+)px and window height to (\d+)px$/) do |window_width, window_height|
	@driver.manage.window.resize_to(window_width, window_height)
end

When(/^I refresh the page$/) do
	@driver.navigate.refresh
end

When(/^I press Escape key$/) do
	@driver.action.send_keys(:escape).perform
end

Then(/^I should see page title "(.*?)"$/) do |title|
	assert_equal(title, @driver.title)
end

Then(/^I should see page url "(.*?)" \(with slashes\)$/) do |url|
	assert_equal(SITE_URL + url, @driver.current_url)
end

Then(/^I should have a browser window opened which contains partial url "(.*?)"$/) do |partial_url|
	assert_equal(true, is_window_present(partial_url))
end
