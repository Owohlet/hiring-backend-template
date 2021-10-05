require 'spec_helper'

RSpec.describe 'Normalizer' do
  describe '#call' do
    let(:params) do
      {
        dollar_format: File.read('spec/fixtures/people_by_dollar.txt'),
        percent_format: File.read('spec/fixtures/people_by_percent.txt'),
        order: :city,
      }
    end
    
    it 'parses the input files and outputs normilized data ordered by city' do
      result = Normalizer.new(params).call

      expect(result).to eq ["Mckayla, Atlanta, 5/29/1986", 
        "Rhiannon, Los Angeles, 4/30/1974", 
        "Elliot, New York City, 5/4/1947", 
        "Rigoberto, New York City, 1/5/1962"
      ]
    end

    it 'makes sure the return object class is an Array' do
      result = Normalizer.call(params)

      expect(result.class).to eq Array
    end
  end
end
