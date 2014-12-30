Feature: Test blog page

	Background:
		Given I visit "blog" page

	Scenario Outline: Page title and url should be correct
		When I set window width to <width>px
		Then I should see page title "Blog - Yi Zeng"
		And I should see page url "/blog/" (with slashes)

		Examples:
			| width |
			| 240   |
			| 480   |
			| 720   |
			| 1280  |
			| 1920  |
