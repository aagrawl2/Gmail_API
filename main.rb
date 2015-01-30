<<<<<<< HEAD
require_relative './lib/gmail'
require_relative './lib/upload_s3'
require_relative './lib/helpers' 
=======
require './lib/Google_Oauth.rb'
require	 './lib/gmail.rb'

require 'rubygems'
require 'rest_client'
require 'json'
require 'zip'
require 'csv'
require 'base64'
require 'aws-sdk'


>>>>>>> FETCH_HEAD

#INPUT PARAMETERS FOR GOOGLE OAUTH
client_id         = '' 
client_secret     = ''
refresh_token     = ''
email 			  = ''

#INPUT PARAMETERS FOR S3 BUCKET
ACCESS_KEY_ID = ''
SECRET_ACCESS_KEY = ''
BUCKET = 'gdc-ms-cust'
#Put '/' sign in the last of the path name
PATH_TO_S3_FOLDER=''
OUTPUT_CSV = ''

#Initializing new object for S3 class which implicitly create new s3 bucket and send credentails
#Please remove this part if you don't wanna upload files to S3
s3_object = UploadS3.new(ACCESS_KEY_ID,SECRET_ACCESS_KEY,BUCKET)

#Initializing Gmail Class
token = Gmail.new(client_id,client_secret,refresh_token, email)

#Download all attachments from the given email with label :"Omniture"
<<<<<<< HEAD
#This will returm the messages id & file_names of attachments associated with the message
messages,file_names = token.download_attachments()

puts messages
=======
messages,file_names = token.download_attachments()
>>>>>>> FETCH_HEAD

file_names.each do |item|
<<<<<<< HEAD

	#Its possible that the attachments are zipped & we just want to extract the csv files so lets make use of unzip library 
	#This piece of code can be removed if we don't wanna unzip anything. This function will return file name unzipped that can used to S3 upload
	if item.include?'.zip'
		item = Helpers.unzip_to_csv(item) 
	end
	
	#Upload files to S3
	s3_object.upload(item,PATH_TO_S3_FOLDER)	
end


#Move Messages to Trash
trash = token.move_messages_trash(messages)

=======
	FINAL_FILE_PATH= PATH_TO_S3_FOLDER + item
	# Upload changes to S3
 	bucket.objects[FINAL_FILE_PATH].write(:file => item)
end

#Move Messages to Trash
trash = token.move_messages_trash(messages)
>>>>>>> FETCH_HEAD
