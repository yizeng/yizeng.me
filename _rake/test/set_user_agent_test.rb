require 'selenium-webdriver'
require 'test/unit'

module SetUserAgent

	class SetUserAgentTests < Test::Unit::TestCase

		USER_AGENT = 'Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10;'

		def teardown
			@driver.quit unless @driver.nil?
		end

		def get_actual_user_agent
			@driver.get('http://www.useragentstring.com/')

			wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
			ua_textarea = wait.until { @driver.find_element(:id, 'uas_textfeld') }
			return ua_textarea.attribute('value')
		end

		def test_setting_firefox_user_agent
			profile = Selenium::WebDriver::Firefox::Profile.new
			profile['general.useragent.override'] = USER_AGENT
			@driver = Selenium::WebDriver.for :firefox, :profile => profile

			assert_equal(USER_AGENT, get_actual_user_agent())
		end

		def test_setting_chrome_user_agent
			@driver = Selenium::WebDriver.for :chrome, :switches => %W[--no-sandbox=true --user-agent=#{USER_AGENT}]

			assert_equal(USER_AGENT, get_actual_user_agent())
		end

		def test_setting_phantomjs_user_agent
			capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => USER_AGENT)
			@driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities

			assert_equal(USER_AGENT, get_actual_user_agent())
		end
	end
end
