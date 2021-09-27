require 'driver'
require 'date'

RSpec.describe Driver do
  describe "#count_period" do
    it "returns the days of the given period" do
      three_days_period = Date.today..Date.today + 2
      driver = Driver.new(three_days_period, 20)

      expect(driver.count_period).to eq 3
    end
  end

  describe "#from_json" do
    it "returns a Driver instance from a json content" do
      json = {"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 100}

      driver = Driver.from_json json

      expect(driver).to have_attributes(period: Date.parse('2017-12-8')..Date.parse('2017-12-10'),
                                        approximate_distance: 100)
    end

  end
end
