# LA County Voter Neighborhood Study

The point of this study is better understand residential preferences and why people select certain neighborhoods. A second important point is to understand the feasibility of using publicly available emails from voter files to conduct public opinion research. 

## Understanding Neighborhood Preferences

## Voter File Emails + Sendgrid

Sendgrid is a service that allows batch emails. The free education package is limited to 15,000 emails per month. I upgraded to the 100K service which allows me to send 100,000 emails per month for $20.00 per month. One of the things that is really expensive in any batch mailer is the list management. Sendgrid only allows you to store 2,000 contacts for free. Storing over 600,000 is very expensive. Here is some code I wrote the makes it fairly easy to send emails without using the supplied list. This pulls the email and name from a '.csv' file, configures the 'html' for the email to have the name and unique link, and then sends an email using Sendgrid's API. 

```{r}

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
    

```