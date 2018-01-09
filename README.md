# LA County Voter Neighborhood Study

The point of this study is better understand residential preferences and why people select certain neighborhoods. A second important point is to understand the feasibility of using publicly available emails from voter files to conduct public opinion research. 

## Understanding Neighborhood Preferences

## Voter File Emails + Sendgrid

Sendgrid is a service that allows batch emails. The free education package is limited to 15,000 emails per month. I upgraded to the 100K service which allows me to send 100,000 emails per month for $20.00 per month. One of the things that is really expensive in any batch mailer is the list management. Sendgrid only allows you to store 2,000 contacts for free. Storing over 600,000 is very expensive. Here is some code I wrote the makes it fairly easy to send emails without using the supplied list. This pulls the email and name from a '.csv' file, configures the 'html' for the email to have the name and unique link, and then sends an email using Sendgrid's API. 

