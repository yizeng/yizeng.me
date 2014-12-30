Then(/^I should see title header "(.*?)"$/) do |title|
	assert_equal(true, @page.title_header.displayed?)
	assert_equal(false, @page.title_header.text.empty?)

	assert_equal(title, @page.title_header.text)
end

Then(/^I should have posts grouped by "(.*?)"$/) do |list_names|
	list_names = list_names.split(', ')

	assert_equal(true, list_names.count > 0)
	assert_equal(list_names.count, @page.list_year_headers.count)

	@page.list_year_headers.each do |list_year_header|
		assert_equal(true, list_names.include?(list_year_header.text))
	end
end

Then(/^I should have clickable post links$/) do
	assert_equal(true, @page.posts.count > 0)

	@page.posts.each do |post|
		link = post.find_element(:tag_name => 'a')

		assert_equal(false, link.text.empty?)
		assert_equal(true, is_link_clickable(link))
	end
end

Then(/^I should (not see|see) date displayed for each post$/) do |target|
	assert_equal(true, @page.posts.count > 0)

	@page.posts.each do |post|
		date = post.find_element(:class => 'date')

		if target == 'see'
			assert_equal(true, date.displayed?)
		end
		if target == 'not see'
			assert_equal(false, date.displayed?)
		end
	end
end