Feature: Test blog page footer

	Background:
		Given I visit "blog" page

	Scenario Outline: Footer's 'about' link should be clickable
		When I set window width to <width>px
		Then I should have clickable footer's 'about' link

		Examples:
			| width |
			| 240   |
			| 480   |
			| 720   |
			| 1280  |
			| 1920  |

	Scenario Outline: Footer's social icons should be in different sizes depending on window width
		When I set window width to <width>px
		Then I should see footer's social icons in <size>px square

		Examples:
			| width | size |
			| 240   | 36   |
			| 480   | 36   |
			| 720   | 42   |
			| 1280  | 42   |
			| 1920  | 42   |

	Scenario Outline: Footer's social icons should be clickable in all window widths
		When I set window width to <width>px
		Then I should have clickable footer's social icon links

		Examples:
			| width |
			| 240   |
			| 480   |
			| 720   |
			| 1280  |
			| 1920  |

	Scenario Outline: Footer's social icons should be working as intended
		When I click footer social icon with title "<icon_title>"
		Then I should have a browser window opened which contains partial url "<social_site_url>"

		Examples:
			| icon_title     | social_site_url                 |
			| Email          | scr.im/yizengme                |
			| LinkedIn       | nz.linkedin.com/in/yizengnz     |
			| RSS            | rss.xml                         |
			| GitHub         | github.com/yizeng               |
			| StackOverflow  | stackoverflow.com/users/1177636 |