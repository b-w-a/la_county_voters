# LA County Voter Neighborhood Study

The point of this study is better understand residential preferences and why people select certain neighborhoods. A second important point is to understand the feasibility of using publicly available emails from voter files to conduct public opinion research. 

## Understanding Neighborhood Preferences

Why do people select certain neighborhoods over others? This question has been central to my dissertation research for some time. Unfortunately, it's a hard question to tease apart for multiple reasons. People don't move very often thus there is not much variation among people. Second, its nearly impossible to casually identify why some people select into certain neighborhoods. If neighborhood context is related to important political science and identity outcomes, as my other work suggests, I need to show that those outcomes are not caused by the act of selecting into a neighborhood conditional on those characteristics. Simply put, are people with strong group identity the ones that are more likely to move into neighborhoods where the contextual stimuli and attributes are more ethnic? If this is the case, I have a pretty strong case that neighborhood level factors, while related to identity outcomes, are indeed endogenous with those outcomes. My idea here is to use a conjoint to test this hypothesis. A conjoint allows me to randomly vary certain attributes associated with a neighborhood and then back out the effect each one has in the overall residential selection calculus. 

## Voter File Emails + Sendgrid

Sendgrid is a service that allows batch emails. The free education package is limited to 15,000 emails per month. I upgraded to the 100K service which allows me to send 100,000 emails per month for $20.00 per month. One of the things that is really expensive in any batch mailer is the list management. Sendgrid only allows you to store 2,000 contacts for free. Storing over 600,000 is very expensive. Here is some code I wrote the makes it fairly easy to send emails without using the supplied list. This pulls the email and name from a `.csv` file, configures the 'html' for the email to have the name and unique link, and then sends an email using Sendgrid's API. 

+ It takes about an hour to loop through 35,000 respondents. 

```{r}
import sendgrid
import os
from sendgrid.helpers.mail import *
import re

# static 
sg = sendgrid.SendGridAPIClient(apikey=your_key_here)
from_email = Email("research@polisci.ucla.edu") #sending email 

# control email 
# This is the HTML text I use to format the email. 
ControlHtml = open("/Users/bryanwilcox/Dropbox/projects/email_study/uclaucomm-ucla-responsive-email-boilerplate-f61e4698f977/test_email.html", 'r') 
control_source_html = ControlHtml.read() 
subject = "We want to hear your thoughts!" # subject line 
# respondents with email and link
control_respondents = [x.strip() for x in open('/Users/bryanwilcox/Dropbox/projects/email_study/samples/clean_pilot.csv', 'r').read().split("\n")]


for respondent in control_respondents[1:]:
    name, email, link = respondent.split(",")
    # print name
    # print email
    # print link
    named_html = re.sub('Name',name, control_source_html) # sub respondent name
    named_html_2 = re.sub('unique_link',link, named_html) # sub unique link
    #print named_html_2
    content = Content("text/html", named_html_2) 
    to_email = Email(email)
    mail = Mail(from_email, subject, to_email, content) # send the email
    response = sg.client.mail.send.post(request_body=mail.get()) 
    print response.status_code # make sure it goes through
```

+ Here is come code I used to generate the sample. I wanted to sample the respondents with different probabilities since some strata are more likely to respond to others. 