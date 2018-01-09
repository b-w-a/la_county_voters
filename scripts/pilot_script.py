# Bryan Wilcox-Archuleta
# Jan 8, 2017 
# Email Study Pilot Survey

# This code sends one batch of emails to 35,000 people for the pilot.
# The full version of the script has a pilot and a control group to test
# whether or not incentivising people makes them more or less likely to 
# participate. 

import sendgrid
import os
from sendgrid.helpers.mail import *
import re

# static 
sg = sendgrid.SendGridAPIClient(apikey=your_key_here)
from_email = Email("research@polisci.ucla.edu")

# control email 
ControlHtml = open("/Users/bryanwilcox/Dropbox/projects/email_study/uclaucomm-ucla-responsive-email-boilerplate-f61e4698f977/test_email.html", 'r')
control_source_html = ControlHtml.read() 
subject = "We want to hear your thoughts!"
#control_respondents = [x.strip() for x in open('/Users/bryanwilcox/Dropbox/projects/email_study/samples/clean_pilot.csv', 'r').read().split("\n")]
control_respondents = [x.strip() for x in open('/Users/bryanwilcox/Dropbox/projects/email_study/samples/test_sample.csv', 'r').read().split("\n")]


for respondent in control_respondents[1:]:
    name, email, link = respondent.split(",")
    print name
    print email
    print link
    named_html = re.sub('Name',name, control_source_html)
    named_html_2 = re.sub('unique_link',link, named_html)
    #print named_html_2
    content = Content("text/html", named_html_2)
    to_email = Email(email)
    mail = Mail(from_email, subject, to_email, content)
    response = sg.client.mail.send.post(request_body=mail.get())
    print response.status_code
    