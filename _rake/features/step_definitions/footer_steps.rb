When(/^I click footer social icon with title "(.*?)"$/) do |title|
	@page.footer.find_social_link(title).click
end

Then(/^I should have clickable footer's 'about' link$/) do
	assert_equal(true, is_link_clickable(@page.footer.about_link))
end

Then(/^I should see footer's social icons in (\d+)px square$/) do |size|
	assert_equal(true, @page.footer.social_links.count > 0)

	@page.footer.social_links.each do |img|
		assert_equal(true, is_link_clickable(img))

		assert_equal(size, img.attribute('clientWidth'))
		assert_equal(size, img.attribute('clientHeight'))
	end
end

Then(/^I should have clickable footer's social icon links$/) do
	assert_equal(true, @page.footer.social_links.count > 0)

	@page.footer.social_links.each do |link|
		assert_equal(true, is_link_clickable(link))
	end
end