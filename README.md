# Gmail API Ruby Code
A simple Gmail API client for Ruby which downloads email attachments and back it up to Amazon S3 . It is based on Gmail Oauth2 mechanism.

####Notes
1) Oauth2 credentials (client id, client secret, refresh token) are needed before running the script. If you have not generated refresh token take reference : https://github.com/aagrawl2/Ruby/blob/master/generate_refresh_token.rb
reference for scope : https://developers.google.com/gmail/api/auth/scopes

2) Scopes needed for Oauth 2 are : https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/gmail.readonly	

2) Gmail user login is required as an input parameter

3) Amazon S3 credentials are required if backing up to S3 else remove that piece of code

####Steps
1) Initialize S3 bucket

2) Create new Gmail class object 
  
      a) Create Google_Oaut2 class object that generates fresh access token

3) Get a list of emails which have label "Omniture"

4) Get a list of all attachments from these emails 

5) Download all attachments locally 

6) Backup all downloaded files to S3

7) Move the emails that have been backed up to TRASH

