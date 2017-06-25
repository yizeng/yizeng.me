module Pages
  class HomePage
    def initialize(driver)
      @driver = driver
    end

    def get_navbar_link(name)
      @driver.find_element(css: "[href='##{name}']")
    end

    def navbar_toggle
      @driver.find_element(css: '.navbar-toggle')
    end

    def navbar_brand
      @driver.find_element(css: '.navbar-brand')
    end

    def navbar_about
      @driver.find_element(css: '[href="#about"]')
    end

    def navbar_blog
      @driver.find_element(css: '[href="#blog"]')
    end

    def navbar_contact
      @driver.find_element(css: '[href="#contact"]')
    end

    def heading_brand
      @driver.find_element(css: '.brand-heading')
    end

    def intro_text
      @driver.find_element(css: '.intro-text')
    end

    def section_about
      @driver.find_element(id: 'about')
    end

    def section_blog
      @driver.find_element(id: 'blog')
    end

    def section_contact
      @driver.find_element(id: 'contact')
    end

    def header_social_link_buttons
      @driver.find_elements(css: '.banner-social-buttons .btn')
    end
  end
end
