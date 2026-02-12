require "selenium-webdriver"
require "rspec"
require 'webdrivers'  # ensures correct ChromeDriver

RSpec.describe "Testing framework" do

  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

  end

  after(:all)do
    @driver.quit
  end

  context 'testing elements' do

    it "Open demo qa" do
      @driver.navigate.to "https://demoqa.com/"

      wait = Selenium::WebDriver::Wait.new(timeout: 10)

      element = wait.until {
        @driver.find_element(xpath: "//h5[text()='Elements']")
      }

      # SCROLL FIRST
      @driver.execute_script(
        "arguments[0].scrollIntoView({block: 'center'});",
        element
      )

      # NOW check visibility
      puts element.displayed? ? "Element is visible" : "Element is NOT visible"

      # WAIT until clickable (important)
      wait.until { element.displayed? && element.enabled? }

      element.click


    end

    it 'Fetch content of table' do
      element = @driver.find_element(xpath: "//*[@class='left-pannel']")
      puts element.displayed? ? "Element is visible" : "Element is NOT visible"

      puts "---element text---"
      puts element.text

      arr = element.text.split("\n")   # split by line
      puts "---element in array---"
      arr.pop
      puts arr.inspect

      expect(arr).to eq(["Elements", " Text Box", "Check Box", "Radio Button", "Web Tables", "Buttons", "Links", "Broken Links - Images", "Upload and Download", "Dynamic Properties", "Forms", " Alerts, Frame & Windows", " Widgets", " Interactions", " Book Store Application"])
    end

    it 'Fill the details' do
      button = @driver.find_element(xpath: "//span[text()='Text Box']")
      button.click

      text = @driver.find_element(id: "userName")
      text.send_keys("Tushar Saxena")

      email = @driver.find_element(id: "userEmail")
      email.send_keys("testqa98@gmail.com")

      submit = @driver.find_element(id: "submit")

      @driver.execute_script(
        "arguments[0].scrollIntoView({block: 'center'});", submit)

      submit.click
      puts"-----------------------------"
      content_output=@driver.find_element(id: "output")
      content_output= content_output.text

      lines=content_output.lines
      pairs= lines.map do |line|
        parts=line.split(":")
        parts.map {|p| p.strip}
      end
      content_output=pairs.to_h
      puts"--content_output----#{content_output}"
      expect(content_output["Name"]).to eq("Tushar Saxena")
      expect(content_output["Email"]).to eq("testqa98@gmail.com")
    end

    it 'Select all the checkboxes by clicking on home checkupbox' do
      @driver.find_element(xpath:"//span[text()='Check Box']").click

      checkbox=@driver.find_element(css:"label[for='tree-node-home'] [class='rct-checkbox']")
      checkbox.click
      sleep 2

      content= @driver.find_element(id:"result").text
      content=content.split("\n")
      puts"-----content is:  #{content}"

      expect(content).to eq(["You have selected :", "home", "desktop", "notes", "commands", "documents", "workspace", "react", "angular", "veu", "office", "public", "private", "classified", "general", "downloads", "wordFile", "excelFile"])
    end

  end

end