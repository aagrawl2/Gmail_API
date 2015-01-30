require 'zip'
require 'csv'

module Helpers
	
	def self.unzip_to_csv(file_name)
		Zip::File.open(file_name) do |zipfile|
			zipfile.each do |file|
				if file.directory?
					puts "#{file.name} is a folder"
				elsif file.symlink?
					puts "#{file.name} is a symlink"
	  				#csv = zipfile.read(file)
	  			elsif file.file?
	  				puts "#{file.name} is a regular file"
	  				
	  				csv = file.get_input_stream.read
					
					#Build Path where unzipped files can be stored
					
					open(file.name,'wb') do |file|
						file.write(csv)
					end
					return file.name
				else
					"#{file.name} is unknown"
				end
    		end
		end
	end
end
