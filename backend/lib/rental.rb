class Rental
  attr_reader :id, :driver, :car

  def initialize(id, car, driver)
    @id = id
    @car = car
    @driver = driver
  end

  def price
    time_price + distance_price
  end

  def as_json
    {
        id: @id,
        price: price
    }
  end

  private

  def time_price
    @driver.count_period * @car.price_per_day
  end

  def distance_price
    @driver.approximate_distance * @car.price_per_km
  end
end
