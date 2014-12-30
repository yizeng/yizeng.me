require 'selenium-webdriver'
require 'test/unit'

module GetTextFromHiddenElements

	module CommonComponents

		DEMO_PAGE = <<-eos
			data:text/html,
			<p>Demo page for how to get text from hidden elements using Selenium WebDriver.</p>
			<div id='demo-div'>Demo div <p style='display:none'>with a hidden paragraph inside.</p><hr /><br /></div>
		eos
		EXPECTED_INNERHTML = 'Demo div <p style="display:none">with a hidden paragraph inside.</p><hr><br>'
		EXPECTED_TEXTCONTENT = 'Demo div with a hidden paragraph inside.'

		def teardown
			@driver.quit unless @driver.nil?
		end

		def test_getting_text_by_innerhtml
			@driver.navigate.to(DEMO_PAGE)

			demo_div = @driver.find_element(:id, 'demo-div')

			assert_equal(EXPECTED_INNERHTML, demo_div.attribute('innerHTML'))
			assert_equal(EXPECTED_INNERHTML, @driver.execute_script("return arguments[0].innerHTML", demo_div))
		end

		def test_getting_text_by_textcontent
			@driver.navigate.to(DEMO_PAGE)

			demo_div = @driver.find_element(:id, 'demo-div')

			assert_equal(EXPECTED_TEXTCONTENT, demo_div.attribute('textContent'))
			assert_equal(EXPECTED_TEXTCONTENT, @driver.execute_script("return arguments[0].textContent", demo_div))
		end
	end

	class GetTextFromHiddenElementsInFirefoxTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :firefox
		end
	end

	class GetTextFromHiddenElementsInChromeJsTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :chrome, :switches => %W[--no-sandbox=true]
		end
	end

	class GetTextFromHiddenElementsInPhantomJsTests < Test::Unit::TestCase
		include CommonComponents

		def setup
			@driver = Selenium::WebDriver.for :phantomjs
		end
	end
end
