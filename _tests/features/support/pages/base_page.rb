require_relative './footer.rb'
require_relative './header.rb'

module Pages
  class BasePage
    def initialize(driver)
      @driver = driver
    end

    def header
      Pages::Header.new(@driver)
    end

    def body_content
      @driver.find_element(css: '.body .content')
    end

    def title_header
      body_content.find_element(css: 'header .entry-title')
    end

    def footer
      Pages::Footer.new(@driver)
    end

    def search_overlay
      Pages::SearchOverlay.new(@driver)
    end
  end
end
