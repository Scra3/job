require 'car'

RSpec.describe Car do
  describe '#from_json' do
    it "returns a car instance from a json content" do
      car = Car.from_json({"id" => 1, "price_per_day" => 2000, "price_per_km" => 10})

      expect(car).to have_attributes(id: 1, price_per_day: 2000, price_per_km: 10)
    end
  end
end
