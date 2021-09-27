require 'date'

class Driver
  attr_reader :period, :approximate_distance, :options

  def initialize(period, approximate_distance, options = [])
    @period = period
    @approximate_distance = approximate_distance
    @options = options
  end

  def count_period
    @period.count
  end

  def self.from_json(json)
    Driver.new(Date.parse(json['start_date'])..Date.parse(json['end_date']),
               json['distance'], json['options'])
  end
end
