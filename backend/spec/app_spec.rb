require 'app'

RSpec.describe App do

  let(:output_path) {'spec/output.json' }
  after(:each) do
    File.delete(output_path) if File.exist?(output_path)
  end

  describe '#run' do
    it "saves a rentals outputs file" do
      App.new("level1/data/input.json", output_path).run

      result = JSON.load File.open output_path
      expected_result = JSON.load File.open 'level1/data/expected_output.json'

      expect(result).to eq expected_result
    end
  end
end
