class Rental
  attr_reader :id, :driver, :car

  def initialize(id, car, driver)
    @id = id
    @car = car
    @driver = driver
  end

  def price
    (time_price + distance_price).to_i
  end

  def insurance_fee
    (commission / 2).to_i
  end

  def assistance_fee
    # the expected_output and the text statement are different.
    # it asks '1€/day goes to the roadside assistance' but in the
    # expected output_file it is 100€/day.
    driver.count_period * 100
  end

  def drivy_fee
    (commission - insurance_fee - assistance_fee).to_i
  end

  def as_json
    {
        id: @id,
        price: price,
        commission: {
            insurance_fee: insurance_fee,
            assistance_fee: assistance_fee,
            drivy_fee: drivy_fee
        }
    }
  end

  private

  def commission
    price * 0.3
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
