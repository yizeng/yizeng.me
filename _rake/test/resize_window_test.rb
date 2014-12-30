require 'selenium-webdriver'
require 'test/unit'

module ResizeWindow

	module CommonComponents
		NEW_WIDTH = 1920
		NEW_HEIGHT = 1080

		def teardown
			@driver.quit unless @driver.nil?
		end

		def test_setting_window_using_dimension
			target_size = Selenium::WebDriver::Dimension.new(NEW_WIDTH, NEW_HEIGHT)
			@driver.manage.window.size = target_size

			assert_equal(NEW_WIDTH, @driver.manage.window.size.width)
			assert_equal(NEW_HEIGHT, @driver.manage.window.size.height)
		end

		def test_resizing_window
			@driver.manage.window.resize_to(NEW_WIDTH, NEW_HEIGHT)

			assert_equal(NEW_WIDTH, @driver.manage.window.size.width)
			assert_equal(NEW_HEIGHT, @driver.manage.window.size.height)
		end
	end

	class ResizeFirefoxWindowTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :firefox
		end
	end

	class ResizeChromeWindowTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :chrome, :switches => %W[--no-sandbox=true]
		end
	end

	class ResizePhantomJsWindowTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :phantomjs
		end
	end
end
