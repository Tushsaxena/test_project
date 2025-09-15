require "selenium-webdriver"
require "rspec"

RSpec.describe "Google seach" do

  it "Open" do

    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "https://www.google.com"

    expect(driver.title).to include("Google")
    driver.quit
  end
end