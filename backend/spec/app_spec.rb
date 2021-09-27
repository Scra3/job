require 'app'

RSpec.describe App do
  let!(:current_level) {'level5'}
  let(:spec_output_path) {'spec/output.json'}

  after(:each) do
    File.delete(spec_output_path) if File.exist?(spec_output_path)
  end

  describe '#run' do
    it "saves a rentals outputs file" do
      App.new("#{current_level}/data/input.json", spec_output_path).run

      result = JSON.load File.open spec_output_path
      expected_result = JSON.load File.open "#{current_level}/data/expected_output.json"

      expect(result).to eq expected_result
    end
  end
end
