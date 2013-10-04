require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Test1" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://133.242.49.86"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_1" do
    @driver.get(@base_url + "/jenkins/")
    @driver.find_element(:link, "selenium").click
    @driver.find_element(:link, "設定").click
    # ERROR: Caught exception [ReferenceError: selectLocator is not defined]
    # ERROR: Caught exception [Error: Dom locators are not implemented yet!]
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
