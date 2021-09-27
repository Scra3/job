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

  def as_json
    {
        id: @id,
        price: price
    }
  end

  private

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
