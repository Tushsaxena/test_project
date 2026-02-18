require "selenium-webdriver"
require "rspec"
require 'webdrivers'  # ensures correct ChromeDriver

RSpec.describe "Testing framework" do

  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize

    #driver.manage.timeouts.implicit_wait = 10
    # This is implicit wait by using this we can wait for each element using find_element for 10 seconds
    # However not preffered because it may slows down, thats why some of the cases we use explicit wait
    # wait = Selenium::WebDriver::Wait.new(timeout: 10)
    #
    # element = wait.until do
    #   el = driver.find_element(id: "username")
    #   el if el.displayed?
    # end
    # In this case we are waiting for specific condition before continuing
  end

  after(:all)do
    @driver.quit
  end

  context 'testing elements' do

    it "Open demo qa" do
      @driver.navigate.to "https://demoqa.com/"
      wait = Selenium::WebDriver::Wait.new(timeout: 10)

      element = wait.until do
        el = @driver.find_element(xpath: "//h5[normalize-space()='Elements']")
        el if el.displayed?
      end

      # Scroll directly to element
      @driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", element)

      # Small wait for layout stabilization
      sleep 0.5

      element.click


    end

    it 'Fetch content of table' do
      @driver.execute_script("window.scrollTo(0, 0);")
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
      @driver.execute_script("window.scrollTo(0, 0);")
      button = @driver.find_element(xpath: "//span[text()='Text Box']")
      button.click

      text = @driver.find_element(id: "userName")
      text.send_keys("Tushar Saxena")

      email = @driver.find_element(id: "userEmail")
      email.send_keys("testqa98@gmail.com")

      submit = @driver.find_element(id: "submit")

      @driver.execute_script(
        "arguments[0].scrollIntoView({block: 'center'});", submit)

      sleep 0.3
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

    it 'Validate side arrow is working and fetch all names' do
      @driver.execute_script("window.scrollTo(0, 0);")
      #Learning for siblings: //span[text()='Desktop']/preceding-sibling::span[@class='rct-checkbox']  ,  //span[text()='Desktop']/parent::label/preceding-sibling::button
      @driver.find_element(xpath:"//span[text()='Check Box']").click
      sleep 2
      #ClickInterceptederror
      element=@driver.find_element(xpath:"//span[@title='Home']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      #@driver.execute_script("arguments[0].click();", element)
      element.click
      sleep 2
      #its css: li.rct-node-expanded
      list=@driver.find_element(xpath:"//div[@class='rc-tree-list']")
      list=list.text.split("\n")
      puts "list------------#{list}"
      expect(list).to eq(["Home", "Desktop", "Documents", "Downloads"])
    end

    it 'Fetch all details from all the checkup box without selecting it' do
      #@driver.navigate.refresh

      #Now open all the checkboxes with arrow and fetch data for all the names
      # When there is space issue, we use normalze-space://span[normalize-space()='Home']/parent::label/preceding-sibling::button
      # home=@driver.find_element(xpath:"//span[@title='Home']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      # @driver.execute_script("arguments[0].click();", home)

      desktop=@driver.find_element(xpath:"//span[@title='Desktop']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      desktop.click

      documents=@driver.find_element(xpath:"//span[@title='Documents']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      documents.click

      workspace=@driver.find_element(xpath:"//span[@title='WorkSpace']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      @driver.execute_script("arguments[0].click();",workspace)

      office=@driver.find_element(xpath:"//span[@title='Office']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      #@driver.execute_script("arguments[0].click();",office)
      @driver.execute_script(
        "arguments[0].scrollIntoView({block: 'center'});",
        office
      )
      office.click

      downloads=@driver.find_element(xpath:"//span[@title='Downloads']/preceding-sibling::span[contains(@class, 'tree-switche')]")
      @driver.execute_script("arguments[0].click();",downloads)

      all_content=@driver.find_element(xpath:"//div[@class='rc-tree-list']")
      all_content=all_content.text.split("\n")
      puts"---all_content----#{all_content}"
      expect(all_content).to eq(["Home", "Desktop", "Notes", "Commands", "Documents", "WorkSpace", "React", "Angular", "Veu", "Office", "Public", "Private", "Classified", "General", "Downloads", "Word File.doc", "Excel File.doc"])
    end

    it 'Select all the checkboxes by clicking on home checkupbox' do
      @driver.execute_script("window.scrollTo(0, 0);")
      @driver.find_element(xpath:"//span[text()='Check Box']").click

      checkbox=@driver.find_element(xpath:"//span[text()='Home']/ancestor::div[@role='treeitem']//span[@role='checkbox']")
      checkbox.click
      sleep 2

      content= @driver.find_element(id:"result").text
      content=content.split("\n")
      puts"-----content is:  #{content}"

      expect(content).to eq(["You have selected :", "home", "desktop", "documents", "downloads", "notes", "commands", "workspace", "office", "wordFile", "excelFile", "react", "angular", "veu", "public", "private", "classified", "general"])
    end

    it 'Click on checkboxes and verify the results' do
      @driver.find_element(css:"[aria-label='Select Notes']").click
      veu=@driver.find_element(css:"[aria-label='Select Veu']")
      @driver.execute_script("arguments[0].scrollIntoView({block: 'center'});",veu)
      sleep 0.5
      veu.click
      private=@driver.find_element(css:"[aria-label='Select Private']")
      @driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", private)
      sleep 0.5
      private.click
      excel=@driver.find_element(css:"[aria-label='Select Excel File.doc']")
      @driver.execute_script(
        "arguments[0].scrollIntoView({block: 'center'});",
        excel
   )
      sleep 0.5
      excel.click

      result=@driver.find_element(id:'result').text
      result=result.split("\n")
      puts"---result-----#{result}"
      expect(result).to eq(["You have selected :", "commands", "wordFile", "react", "angular", "public", "classified", "general"])
    end

  end

  context 'Radio button' do
    it 'Validate that User is able to navigate to radio  button and fetch names of them' do
      @driver.find_element(xpath:"//span[text()='Radio Button']").click
      page_name=@driver.find_element(xpath:"//h1[@class='text-center']").text
      puts"---page_name----#{page_name}"
      expect(page_name).to eq("Radio Button")
      fields=@driver.find_element(xpath:"//div[text()='Do you like the site?']/parent::div").text
      fields=fields.split("\n")
      puts"--fields is:  #{fields}"
      expect(fields).to eq(["Do you like the site?", "Yes", "Impressive", "No"])
    end

    it 'Validate visibility of the buttons' do
      yes_button=@driver.find_element(id:"yesRadio")
      impressive_button=@driver.find_element(id:"impressiveRadio")
      no_button=@driver.find_element(id:"noRadio")

      aggregate_failures do
      expect(impressive_button.displayed?).to eq true
      expect(yes_button.displayed?).to eq true
      expect(no_button.displayed?).to eq true
      expect(impressive_button.enabled?).to eq true
      expect(yes_button.enabled?).to eq true
      expect(no_button.enabled?).to eq false
      end
    end

    it 'Validate that after clicking on radio button correct output is visible'do
      @driver.execute_script("window.scrollTo(0, 0);")
      yes_button=@driver.find_element(id:"yesRadio")
      yes_button.click
      result= @driver.find_element(xpath:"//span[@class='text-success']/parent::p").text
      puts"---result----#{result}"
      expect(result).to eq("You have selected Yes")

      impressive_button=@driver.find_element(id:"impressiveRadio")
      impressive_button.click

      result2=@driver.find_element(xpath:"//span[@class='text-success']/parent::p").text
      puts"---result----#{result2}"
      expect(result2).to eq("You have selected Impressive")
    end
  end

  context 'Web tables' do
    it 'Validate that user is able to navigate to web tables and verify fields on page' do
      @driver.find_element(xpath: "//span[text()='Web Tables']").click

      web_text=@driver.find_element(xpath: "//h1[@class='text-center' and text()='Web Tables']").text
      expect(web_text).to eq('Web Tables')
      add_button=@driver.find_element(id: "addNewRecordButton")
      role_group=@driver.find_element(css: "[role='group']")
      expect(add_button).to be_displayed
      expect(add_button).to be_enabled
      #expect(add_button).to be_displayed.and be_enabled   More cleaner
      expect(role_group).to be_displayed
    end
  end
end