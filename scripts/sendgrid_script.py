# Bryan Wilcox-Archuleta
# Aug. 9, 2017 
# Email Study 

# This code sends batches of emails to two groups of people. 
# One group is the control, on is $100.00 amazon.com gift card. This 
# is the experimental condition. 

import sendgrid
import os
from sendgrid.helpers.mail import *
import re

# static 
sg = sendgrid.SendGridAPIClient(apikey="your_key_here")
from_email = Email("research@polisci.ucla.edu")

# control email 

ControlHtml = open("/Users/bryanwilcox/Dropbox/projects/email_study/uclaucomm-ucla-responsive-email-boilerplate-f61e4698f977/test_email.html", 'r')
control_source_html = ControlHtml.read() 
subject = "We want to hear your thoughts!"
control_respondents = [x.strip() for x in open('/Users/bryanwilcox/Dropbox/projects/email_study/samples/Test_Conjoint-Distribution_History.csv', 'r').read().split("\n")]

for respondent in control_respondents[1:4]:
    name, email, voter_id, link = respondent.split(",")
    print name
    print email
    print link
    print voter_id
    named_html = re.sub('Name',name, control_source_html)
    named_html_2 = re.sub('unique_link',link, named_html)
    #print named_html_2
    content = Content("text/html", named_html_2)
    to_email = Email(email)
    mail = Mail(from_email, subject, to_email, content)
    response = sg.client.mail.send.post(request_body=mail.get())
    print response.status_code
    
# experiment email 
ExperimentHtml = open("/Users/bryanwilcox/Dropbox/projects/email_study/uclaucomm-ucla-responsive-email-boilerplate-f61e4698f977/test_email.html", 'r')
experiment_source_html = ExperimentHtml.read() 
subject = "We want to hear your thoughts!"
experiment_respondents = [x.strip() for x in open('/Users/bryanwilcox/Desktop/test_emails_updated.csv', 'r').read().split("\n")]

for respondent in experiment_respondents[1:4]:
    name, email, voter_id, link = respondent.split(",")
    print name
    print email
    print link
    print voter_id
    named_html = re.sub('Name',name, experiment_source_html)
    named_html_2 = re.sub('unique_link',link, named_html)
    #print named_html_2
    content = Content("text/html", named_html_2)
    to_email = Email(email)
    mail = Mail(from_email, subject, to_email, content)
    response = sg.client.mail.send.post(request_body=mail.get())
    print response.status_code
