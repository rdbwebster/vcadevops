# filename: formtest.rb

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  @driver.get 'http://linuxsb:8080/greeting'
  expect(@driver.title).to eql 'Getting Started: Handing Form Submission'
  @driver.save_screenshot 'example1.png'
end
