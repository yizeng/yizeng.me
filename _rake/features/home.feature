Feature: Test home page

	Background:
		Given I visit "home" page

	Scenario Outline: Page title and url should be correct
		When I set window width to <width>px
		Then I should see page title "Yi Zeng"
		And I should see page url "/" (with slashes)

		Examples:
			| width |
			| 240   |
			| 320   |
			| 640   |
			| 768   |
			| 1280  |
			| 1920  |

	Scenario Outline: Navigation circles should be visible depending on width
		When I set window width to <width>px
		Then I should <have?> clickable navigation circles
		And I click continue button
		And I should <have?> clickable navigation circles

		Examples:
			| width | have?    |
			| 240   | not have |
			| 320   | not have |
			| 640   | have     |
			| 768   | have     |
			| 1280  | have     |
			| 1920  | have     |

	Scenario Outline: Navigating between pages should work properly
		When I set window width to <width>px
		Then I wait for bio page to be loaded
		And I should see bio page loaded
		And I should not see social page loaded
		When I click continue button
		And I wait for social page to be loaded
		Then I should see social page loaded
		And I should not see bio page loaded

		Examples:
			| width |
			| 240   |
			| 320   |
			| 640   |
			| 768   |
			| 1280  |
			| 1920  |

	Scenario Outline: Social icons should be in different sizes depending on window width
		When I set window width to <width>px and window height to <height>px
		And I wait for bio page to be loaded
		And I click continue button
		And I wait for social page to be loaded
		Then I should see social page's social links in <size>px square

		Examples:
			| width | height | size |
			| 240   | 240    | 36   |
			| 240   | 768    | 36   |
			| 320   | 240    | 36   |
			| 320   | 768    | 36   |
			| 640   | 240    | 48   |
			| 640   | 768    | 48   |
			| 768   | 240    | 48   |
			| 768   | 768    | 64   |
			| 1280  | 240    | 48   |
			| 1280  | 768    | 64   |
			| 1920  | 240    | 48   |
			| 1920  | 768    | 64   |