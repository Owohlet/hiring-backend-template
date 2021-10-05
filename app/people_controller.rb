class PeopleController
	require './app/services/normalizer.rb' #uncomment this line to run rspec
	def initialize(params)
		@params = params
	end

	def normalize
		result = Normalizer.call(@params)
		return result
	end

	private

	attr_reader :params
end
