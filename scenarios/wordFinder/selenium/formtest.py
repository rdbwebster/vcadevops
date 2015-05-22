
#!/usr/bin/env python

from pyvirtualdisplay import Display
from selenium import webdriver

display = Display(visible=0, size=(800, 600))
display.start()

# now Firefox will run in a virtual display. 
# you will not see the browser.
browser = webdriver.Firefox()
# Cannot test from inside against devops.vcloudair.io not gateway support for hairpin nat (out and back in again)
browser.get('http://linuxsb:3000/greeting')

 # <form action="/greeting" method="post">
 #   	<p>Id: <input type="text" id="id" name="id" value="0" /></p>
 #       <p>Message: <input type="text" id="content" name="content" value="" /></p>
 #       <p><input type="submit" value="Submit" /> <input type="reset" value="Reset" /></p>
 #   </form>

print browser.title
el = browser.find_element_by_name('content')
el.send_keys('hello')

submit = browser.find_element_by_xpath("//input[@value='Submit']")
#submit = browser.find_element_by_xpath("//form[1]/input[3]")
submit.click()
browser.save_screenshot('screenshot.png')

element = browser.find_element_by_css_selector('a').click()

browser.quit()

display.stop()
