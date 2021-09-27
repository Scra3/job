context 'integration test to verify the running command' do
  let!(:current_level) {'level5'}
  let(:output_path) {"#{current_level}/data/output.json"}

  after(:each) do
    File.delete(output_path) if File.exist?(output_path)
  end

  it 'runs the main script and generates an output file' do
    system("cd #{current_level} && ruby main.rb")

    expect(File.exists? output_path).to be_truthy
  end
end
