require 'driver'
require 'rental'
require 'car'
require 'date'

RSpec.describe Rental do
  let(:three_days_period) {Date.today..Date.today + 2}
  let(:a_driver) {Driver.new(three_days_period, 20)}
  let(:car) {Car.new(1, 10, 15)}

  describe '#price' do
    let(:one_day_reduction) {car.price_per_day - car.price_per_day * 0.1}
    let(:four_days_reduction) {car.price_per_day - car.price_per_day * 0.3}
    let(:ten_days_reduction) {car.price_per_day - car.price_per_day * 0.5}

    context 'price does not decrease when the period is one day' do
      it "returns the price by given a driver and a car" do
        driver = Driver.new(Date.today..Date.today, 20)
        rental = Rental.new(1, car, driver)

        expected_price = car.price_per_day * driver.count_period + car.price_per_km * driver.approximate_distance
        expect(rental.price).to eq expected_price
      end
    end

    context 'price per day decreases by 10% after 1 day' do
      it "returns the price by given a driver and a car" do
        driver = Driver.new(Date.today..Date.today + 1, 20)
        rental = Rental.new(1, car, driver)

        expected_price = car.price_per_day + one_day_reduction + car.price_per_km * driver.approximate_distance
        expect(rental.price).to eq expected_price
      end
    end

    context 'price per day decreases by 30% after 4 days' do
      it "returns the price by given a driver and a car" do
        driver = Driver.new(Date.today..Date.today + 4, 20)
        rental = Rental.new(1, car, driver)

        expected_price = car.price_per_day + one_day_reduction * 3 + four_days_reduction + car.price_per_km * driver.approximate_distance
        expect(rental.price).to eq expected_price
      end
    end

    context 'price per day decreases by 50% after 10 days' do
      it "returns the price by given a driver and a car" do
        driver = Driver.new(Date.today..Date.today + 10, 20)
        rental = Rental.new(1, car, driver)

        expected_price = car.price_per_day + one_day_reduction * 3 + four_days_reduction * 6 + ten_days_reduction + car.price_per_km * driver.approximate_distance
        expect(rental.price).to eq expected_price
      end
    end
  end

  describe '#insurance_fee' do
    it "returns the half of the commission" do
      driver = Driver.new(Date.today..Date.today + 1, 20)

      rental = Rental.new(1, car, driver)

      expect(rental.insurance_fee).to eq((rental.price * 0.3 / 2).to_i)
    end
  end

  describe '#assistance_fee' do
    it "returns 100€/day" do
      driver = Driver.new(Date.today..Date.today + 1, 20)

      rental = Rental.new(1, car, driver)

      expect(rental.assistance_fee).to eq rental.driver.count_period * 100
    end
  end

  describe '#drivy_fee' do
    it "returns the rest of the commission" do
      driver = Driver.new(Date.today..Date.today + 1, 20)

      rental = Rental.new(1, car, driver)

      expect(rental.drivy_fee).to eq((rental.price * 0.3 - rental.assistance_fee - rental.insurance_fee).to_i)
    end
  end

  describe '#total_fee' do
    it "returns the total fee" do
      driver = Driver.new(Date.today..Date.today + 1, 20)

      rental = Rental.new(1, car, driver)

      expect(rental.total_fee).to eq(rental.drivy_fee + rental.assistance_fee + rental.insurance_fee)
    end
  end

  describe '#as_json' do
    it "returns the json contents with action payments" do
      rental = Rental.new(1, car, a_driver)

      expect(rental.as_json[:actions].length).to eq(5)
      expect(rental.as_json[:id]).to eq(1)
    end
  end
end
