Feature: Test blog page body

  Background:
    Given I visit "blog" page

  Scenario Outline: Body's title header should be displayed
    When I set window width to <width>px
    Then I should see title header "All Posts"

    Examples:
      | width |
      | 240   |
      | 480   |
      | 720   |
      | 1024  |
      | 1280  |
      | 1920  |

  Scenario Outline: Body should list posts
    When I set window width to <width>px
    Then I should have posts grouped by year
    And I should have clickable post links

    Examples:
      | width |
      | 240   |
      | 480   |
      | 720   |
      | 1024  |
      | 1280  |
      | 1920  |

  Scenario Outline: Body's post lists should show dates depending on window width
    When I set window width to <width>px
    Then I should <see?> date displayed for each post

    Examples:
      | width | see?    |
      | 240   | not see |
      | 480   | not see |
      | 720   | not see |
      | 1024  | not see |
      | 1280  | see     |
      | 1920  | see     |
