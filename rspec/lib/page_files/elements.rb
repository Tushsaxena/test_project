class ElementsPage

  def initialize(driver)
    @driver=driver
  end
  def add_person(first_name, last_name, email,age, salary, department)
    add_button=@driver.find_element(id:"addNewRecordButton")
    add_button.click

    first_name_fill=@driver.find_element(id:"firstName")
    first_name_fill.clear unless first_name_fill.attribute("value").empty?
    first_name_fill.send_keys(first_name)

    last_name_fill=@driver.find_element(id:"lastName")
    last_name_fill.send_keys(last_name)

    email_fill=@driver.find_element(id:"userEmail")
    email_fill.send_keys(email)

    age_fill=@driver.find_element(id:"age")
    age_fill.send_keys(age)

    salary_fill=@driver.find_element(id:"salary")
    salary_fill.send_keys(salary)

    department_fill=@driver.find_element(id:"department")
    department_fill.send_keys(department)

    @driver.find_element(id:"submit").click

  end

  def fetch_form_data
    data=@driver.find_element(xpath:"//table[contains(@class,'table-hover')]")
    puts"---data-------#{data.text}"
    data=data.text
    data=data.split("\n")

    value=["First Name", "Last Name", "Age" ,"Email", "Salary" ,"Department"]
    arr=[]

    for i in 1..data.length-1
      values=Hash[value.zip(data[i].split(" "))]
      arr<<values
    end

    arr
  end

  def fetch_data_with_name(arr,name)
    arr.each do |element|
      if element["First Name"]==name
        return element
      end
    end

  end
end