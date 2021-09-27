require_relative 'payment_action'

class Rental
  OPTIONS = {gps: 'gps', baby_seat: 'baby_seat', additional_insurance: 'additional_insurance'}

  attr_reader :id, :driver, :car

  def initialize(id, car, driver)
    @id = id
    @car = car
    @driver = driver
  end

  def price
    (time_price + distance_price + options_price).to_i
  end

  def price_without_options
    (time_price + distance_price).to_i
  end

  def total_fee
    insurance_fee + assistance_fee + drivy_fee
  end

  def insurance_fee
    (commission / 2).to_i
  end

  def assistance_fee
    driver.count_period * 100
  end

  def drivy_fee
    (commission - insurance_fee - assistance_fee).to_i
  end

  def gps_option_price
   @driver.options.include?(OPTIONS[:gps]) ? 500 * @driver.count_period : 0
  end

  def baby_seat_option_price
   @driver.options.include?(OPTIONS[:baby_seat]) ? 200 * @driver.count_period : 0
  end

  def additional_insurance_option_price
   @driver.options.include?(OPTIONS[:additional_insurance]) ? 1000 * @driver.count_period : 0
  end

  def as_json
    {
        id: @id,
        options: @driver.options,
        actions: PaymentAction.new(self).as_json,
    }
  end

  private

  def options_price
    additional_insurance_option_price + baby_seat_option_price + gps_option_price
  end

  def commission
    price_without_options * 0.3
  end

  def time_price
    (1..@driver.count_period).map do |day_index|
      if day_index > 10
        next(@car.price_per_day - @car.price_per_day * 0.5)
      end
      if day_index > 4
        next(@car.price_per_day - @car.price_per_day * 0.3)
      end
      if day_index > 1
        next(@car.price_per_day - @car.price_per_day * 0.1)
      end
      @car.price_per_day
    end.sum
  end

  def distance_price
    @driver.approximate_distance * @car.price_per_km
  end
end
