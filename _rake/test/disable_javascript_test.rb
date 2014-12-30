require 'selenium-webdriver'
require 'test/unit'

module DisableJavaScript

	class DisableJavaScriptTests < Test::Unit::TestCase

		DEMO_PAGE = <<-eos
			data:text/html,
			<noscript><p class="js-disabled">JavaScript disabled</p></noscript>
			<div>This is a demo page.</div>
		eos

		def teardown
			@driver.quit unless @driver.nil?
		end

		def is_javascript_disabled?
			@driver.get(DEMO_PAGE)
			return @driver.find_element(:class, 'js-disabled').displayed?
		end

		def test_disabling_javascript_in_firefox
			profile = Selenium::WebDriver::Firefox::Profile.new
			profile["javascript.enabled"] = false
			@driver = Selenium::WebDriver.for(:firefox, :profile => profile)

			assert_equal(true, is_javascript_disabled?)
		end

		def test_disabling_javascript_in_phantomjs
			omit("Disabling JavaScript in PhantomJS will stop browser from functioning.\nOmitting ")

			capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.javascriptEnabled" => "false")
			@driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities

			assert_equal(true, is_javascript_disabled?)
		end
	end
end
