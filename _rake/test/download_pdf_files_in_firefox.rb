require 'selenium-webdriver'
require 'test/unit'

module DownloadPdfFilesInFirefox

	class DownloadPdfFilesInFirefoxTests < Test::Unit::TestCase

		DOWNLOAD_DIR = 'C:\\'
		PDF_FILENAME = 'mozilla_privacypolicy.pdf'
		DOWNLOADED_PDF = DOWNLOAD_DIR + PDF_FILENAME

		def teardown
			@driver.quit unless @driver.nil?
			File.delete(DOWNLOADED_PDF) if File.exist?(DOWNLOADED_PDF)
		end

		def test_downloading_pdf_files_in_firefox
			profile = Selenium::WebDriver::Firefox::Profile.new
			profile["browser.download.folderList"] = 2 # use the custom folder defined in "browser.download.dir" below
			profile["browser.download.dir"] = DOWNLOAD_DIR
			profile["browser.helperApps.neverAsk.saveToDisk"] = 'application/pdf'

			# disable Firefox's built-in PDF viewer
			profile["pdfjs.disabled"] = true

			# disable Adobe Acrobat PDF preview plugin
			profile["plugin.scan.plid.all"] = false
			profile["plugin.scan.Acrobat"] = "99.0" # set the minimum allowed version to something large enough

			@driver = Selenium::WebDriver.for :firefox, :profile => profile
			@driver.get("http://static.mozilla.com/moco/en-US/pdf/#{PDF_FILENAME}")

			assert_equal(true, File.file?(DOWNLOADED_PDF))
		end
	end
end