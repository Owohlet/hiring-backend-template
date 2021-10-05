require './app/services/application_service.rb'
require './app/helpers/people_helper.rb'
class Normalizer < ApplicationService
	def initialize(params)
		@params = params
	end

	def call
		# turn files to nested arrays
		dollar_array = dollar_file_to_array(@params[:dollar_format])
		percent_array = percent_file_to_array(@params[:percent_format])

		# rearrange the dollar array to match percent array
		rearranged_dollar_array = rearrange(dollar_array)

		# add both arrays and remove headers
		normalized_data_array =  percent_array + rearranged_dollar_array
		normalized_data_array.shift

		# format the date
		normalized_data_array = format_date_in_array(normalized_data_array)

		# sort array by sort parameter
		sorted_normalized_data_array = sort_by(@params[:order],normalized_data_array)
		return sorted_normalized_data_array.map { |inner_array| inner_array.join(',') }
	end

	def dollar_file_to_array(dollar_format)
		# split file into array and call the organize_array method
		file_data = dollar_format.to_s.split("$").map(&:strip)
		arr = organize_array(file_data)	
		return arr
	end

	def percent_file_to_array(percent_format)
		file_data = percent_format.to_s.split("%").map(&:strip)
		arr = organize_array(file_data)	
		return arr	
	end

	def organize_array(file_data)
		# separate merged entries, organize and return
		arr = []
		subarray = []
		file_data.each do |data|
			if data.include? "\n"
				subarray << data.split("\n").first
				arr << subarray
				subarray = [data.split("\n").last]
			else
				subarray << data
			end

		end

		arr << subarray
		return arr
	end

	def rearrange(arr)
		# select the first_name, city and birthdate into an array then return
		new_array = []
		
		for i in 1...arr.length
			sub_array = [arr[i][3], get_full_city_name(arr[i][0]), arr[i][1]] 
			new_array << sub_array
		end

		return new_array

	end

	def sort_by(sort_parameter,array)
		# sort by inputed parameter
		case sort_parameter
		when :first_name
			order = 0
		when :city
			order = 1
		when :birthdate
			order = 2
		end

		sorted = array.sort { |a,b| a[order] <=> b[order] }
		return sorted
	end

	def format_date_in_array(array)
		array.each do |inner|
			inner[1] = " " +inner[1]
			inner[2] = " " +format_date(inner[2])
		end

		return array
	end
end