require "json"
require_relative "car"
require_relative "driver"
require_relative "rental"


class App
  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
  end

  def run
    data = JSON.load(File.open @input_file)

    cars = data['cars'].map do |json|
      Car.from_json json
    end

    rentals = data['rentals'].map do |json|
      id = json['id']

      options = filter_options_by_rental_id(data['options'], id)
      driver = Driver.from_json(json.merge({"options" => options}))

      car = cars.find {|car| car.id == json['car_id']}

      Rental.new(id, car, driver)
    end

    save_rentals_as_file rentals
  end

  private

  def filter_options_by_rental_id(options, id)
    options.reduce([]) do |filtered_options, option|
      if option['rental_id'] == id
        filtered_options << option['type']
      end
      filtered_options
    end
  end

  def save_rentals_as_file(rentals)
    File.open(@output_file, "w") do |f|
      f.write({rentals: rentals.map(&:as_json)}.to_json)
    end
  end
end
