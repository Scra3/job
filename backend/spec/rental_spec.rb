require 'driver'
require 'rental'
require 'car'
require 'date'

RSpec.describe Rental do
  let(:three_days_period) {Date.today..Date.today + 2}
  let(:driver) {Driver.new(three_days_period, 20)}
  let(:car) {Car.new(1, 10, 15)}

  describe '#price' do
    it "returns the price by given a driver and a car" do
      rental = Rental.new(1, car, driver)

      expected_price = car.price_per_day * driver.count_period + car.price_per_km * driver.approximate_distance
      expect(rental.price).to eq expected_price
    end
  end

  describe '#as_json' do
    it "returns the price and the id attributes as json data" do
      rental = Rental.new(1, car, driver)

      expect(rental.as_json).to eq({id: 1, price: rental.price})
    end
  end
end
