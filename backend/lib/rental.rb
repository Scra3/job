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
    (price_without_options + options_price).to_i
  end

  def price_without_options
    (time_price + distance_price).to_i
  end

  def total_fee
    insurance_fee + assistance_fee + drivy_fee
  end

  def insurance_fee
    insurance_rate = 2
    (commission / insurance_rate).to_i
  end

  def assistance_fee
    assistance_price_by_day = 100
    driver.count_period * assistance_price_by_day
  end

  def drivy_fee
    (commission - insurance_fee - assistance_fee).to_i
  end

  def gps_option_price
    gps_price_by_day = 500
    @driver.options.include?(OPTIONS[:gps]) ? gps_price_by_day * @driver.count_period : 0
  end

  def baby_seat_option_price
    baby_seat_price_by_day = 200
    @driver.options.include?(OPTIONS[:baby_seat]) ? baby_seat_price_by_day * @driver.count_period : 0
  end

  def additional_insurance_option_price
    insurance_price_by_day = 1000
    @driver.options.include?(OPTIONS[:additional_insurance]) ? insurance_price_by_day * @driver.count_period : 0
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
    commission_rate = 0.3
    price_without_options * commission_rate
  end

  def time_price
    (1..@driver.count_period).map do |day_index|
      if day_index > 10
        ten_days_discount_rate = 0.5
        next(@car.price_per_day - @car.price_per_day * ten_days_discount_rate)
      end
      if day_index > 4
        four_days_discount_rate =  0.3
        next(@car.price_per_day - @car.price_per_day * four_days_discount_rate)
      end
      if day_index > 1
        one_day_discount_rate = 0.1
        next(@car.price_per_day - @car.price_per_day * one_day_discount_rate)
      end
      @car.price_per_day
    end.sum
  end

  def distance_price
    @driver.approximate_distance * @car.price_per_km
  end
end
