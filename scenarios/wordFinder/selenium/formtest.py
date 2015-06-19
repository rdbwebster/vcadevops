#!/usr/bin/env python

from pyvirtualdisplay import Display
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

display = Display(visible=0, size=(800, 600))
display.start()

# now Firefox will run in a virtual display. 
# you will not see the browser.
browser = webdriver.Firefox()
# Cannot test from inside against devops.vcloudair.io not gateway support for hairpin nat (out and back in again)
browser.get('http://s2ubu:3000/') 
print browser.title
el = browser.find_element_by_name('pattern')
el.send_keys('he__o')

print "Entered value " + el.get_attribute('value')

# Hit enter key
el.send_keys(Keys.RETURN)


element = WebDriverWait(browser, 10)  #.until(
#        EC.presence_of_element_located((By.ID, "myDynamicElement"))
#)

#div = self.driver.find_element_by_class_name('someclass')
#div.find_element_by_css_selector('a').get_attribute('href')

browser.save_screenshot('screenshot.png')

result = browser.find_element_by_xpath("//div[3]/p")
print result.get_attribute('textContent')

assert "Words found: 2" in browser.page_source
browser.quit()

display.stop()
