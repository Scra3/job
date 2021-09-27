class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end

  def self.from_json(json)
    Car.new(json['id'],
            json['price_per_day'],
            json['price_per_km'])
  end
end
