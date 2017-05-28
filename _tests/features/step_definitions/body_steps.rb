Then(/^I should see title header "(.*?)"$/) do |title|
  assert_equal(true, @page.title_header.displayed?)
  assert_equal(false, @page.title_header.text.empty?)

  assert_equal(title, @page.title_header.text)
end

Then(/^I should have posts grouped by year$/) do
  assert_equal(true, @page.list_year_headers.count > 0)
  @page.list_year_headers.each do |list_year_header|
    assert_equal(true, !!(list_year_header.text =~ /^20\d\d$/))
  end
end

Then(/^I should have clickable post links$/) do
  assert_equal(true, @page.posts.count > 0)

  @page.posts.each do |post|
    link = post.find_element(tag_name: 'a')

    assert_equal(false, link.text.empty?)
    assert_equal(true, is_link_clickable(link))
  end
end

Then(/^I should (not see|see) date displayed for each post$/) do |target|
  assert_equal(true, @page.posts.count > 0)

  @page.posts.each do |post|
    date = post.find_element(class: 'date')

    assert_equal(true, date.displayed?) if target == 'see'
    assert_equal(false, date.displayed?) if target == 'not see'
  end
end
