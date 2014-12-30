Feature: Test blog page post searching

	Background:
		Given I visit "blog" page
		When I set window width to 240px
		And I click header's search button

	Scenario: Close search overlay by clicking close button
		When I close search overlay using 'Close' button
		Then I should have search overlay closed

	Scenario: Close search overlay by pressing Escape
		When I press Escape key
		Then I should have search overlay closed

	Scenario Outline: Search for non-existent content by title
		When I search for "some extreme long title that doesn't exist"
		And I set window width to <width>px
		Then I should see no posts are found

		Examples:
			| width |
			| 240   |
			| 480   |
			| 720   |
			| 1280  |
			| 1920  |

	Scenario Outline: Search for existing posts by title
		When I search for "Selenium"
		And I set window width to <width>px
		Then I should see posts are found

		Examples:
			| width |
			| 240   |
			| 480   |
			| 720   |
			| 1280  |
			| 1920  |

	Scenario Outline: Search for existing posts by title, then close and re-open overlay
		When I search for "Selenium"
		And I set window width to <width>px
		And I close search overlay using 'Close' button
		And I click header's search <element?>
		Then I should see posts are found

		Examples:
			| width | element? |
			| 240   | button   |
			| 480   | button   |
			| 720   | link     |
			| 1280  | link     |
			| 1920  | link     |

	Scenario Outline: Search for existing posts by date
		When I search for "January"
		And I set window width to <width>px
		Then I should see posts are found
		And I should <see?> date in result list

		Examples:
			| width | see?    |
			| 240   | not see |
			| 480   | not see |
			| 720   | not see |
			| 1280  | see     |
			| 1920  | see     |