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
      | 1024  |
      | 1280  |
      | 1920  |

  Scenario Outline: Footer's social icons should be in different sizes depending on window width
    When I set window width to <width>px
    Then I should see footer's social icons in <size>px square

    Examples:
      | width | size |
      | 240   | 32   |
      | 480   | 32   |
      | 720   | 42   |
      | 1024  | 42   |
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
      | 1024  |
      | 1280  |
      | 1920  |

  Scenario Outline: Footer's social icons should be pointing to the correct urls
    Then I should have social link "<title>" contain the correct partial url "<social_site_url>"

    Examples:
      | title          | social_site_url                 |
      | Email          | mailto:dev.yizeng.me            |
      | Feed           | feed.xml                        |
      | GitHub         | github.com/yizeng               |
      | Instagram      | instagram.com/yizeng.me         |
      | LinkedIn       | linkedin.com/in/yizengnz        |
      | StackOverflow  | stackoverflow.com/users/1177636 |
      | VK             | vk.com/yi.zeng                  |
