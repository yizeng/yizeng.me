require_relative './base_page.rb'

module Pages
  class ListView < BasePage
    def posts
      body_content.find_elements(class: 'posts')
    end
  end
end
