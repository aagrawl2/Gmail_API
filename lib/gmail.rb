require_relative './google_oauth'

require 'rest_client'
require 'json'
require 'zip'
require 'csv'
require 'base64'
require 'aws-sdk'


class Gmail

	def initialize (client_id,client_secret,refresh_token,email)
		
		#Generate new access token from Google_Oauth library
		
		@new_token     = GoogleOauth.new(client_id,client_secret,refresh_token)

		#Store the fresh access token as a class variable
		@access_token = @new_token.get_access_token
		@email 		  = email

	end

	def refresh_access_token()
		@access_token = @new_token.get_access_token
	end

	#get a list of messages. This retrieves messages based on a particular label
	def list_of_messages()
		
		#Create a new request
		request_url = "https://www.googleapis.com/gmail/v1/users/#{@email}/messages?labelIds=Label_1&access_token=#{@access_token}"

		#GET REQUEST
		response = RestClient.get request_url
		response_body = JSON.parse(response.body)

		#Looping through all the Messages and grabbing id
		messages= Array.new

		temp = response_body['messages']
		temp.each do |item|
			messages.push(item['id'])
		end 
	
		return messages
	end

	#Get a list of attachments for a given message based on its id

	def get_attachments()
		
		messages = list_of_messages()

		#Initializing Nested Hash so that we can store message_id, file_name and attachemnt id
		files= Hash.new { |l, k| l[k] = Hash.new(&l.default_proc) }
		messages.each do |message_id|
		
			#Create a new request
			request_url = "https://www.googleapis.com/gmail/v1/users/#{@email}/messages/#{message_id}?access_token=#{@access_token}"

			#GET REQUEST
			response = RestClient.get request_url
			response_body = JSON.parse(response.body)

			#Getting list of attachments based on message id
			temp = response_body['payload']['parts']
			temp.each do |item|
				if item['filename'] !=''
					files[message_id][item['filename']]=item['body']['attachmentId']
				end
			end 
		end
		return files
	end

	
	#Download attachments

	def download_attachments()
		
		attachments = get_attachments()
		
		file_names = Array.new
		messages   = Array.new
		attachments.each do |message_id, value|
	
			messages.push(message_id)
			value.each do |file_name,attachment_id|

				file_names.push(file_name)
				#Create a new request
				request_url = "https://www.googleapis.com/gmail/v1/users/#{@email}/messages/#{message_id}/attachments/#{attachment_id}?access_token=#{@access_token}"
				#GET REQUEST
				response = RestClient.get request_url
				response_body = JSON.parse(response.body)

				temp = Base64.urlsafe_decode64(response_body['data'].encode("UTF-8")) 
				
				open(file_name,'wb') do |file|
					file.write(temp)
				end

			end
		end
		return messages,file_names
	end


	#Move Messages to Trash
	def move_messages_trash(messages)
	
		puts messages
		messages.each do |message_id|
			
			request_url = "https://www.googleapis.com/gmail/v1/users/#{@email}/messages/#{message_id}/trash?access_token=#{@access_token}"
			response = RestClient.post request_url, {:content_type => 'application/x-www-form-urlencoded'}
			response_body = JSON.parse(response.body)
			puts response_body
		end
	end

end
