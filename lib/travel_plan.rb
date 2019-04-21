require 'dropoff_point'

class TravelPlan
  attr_reader :vehicle, :start_time, :start_north, :start_east, :end_north, :end_east
  attr_accessor :distance_travelled

  def initialize(vehicle:, start_time:,  start_north: 0, start_east: 0, end_north: 0, end_east: 0)
    @vehicle = vehicle
    @start_time = start_time
    @start_north = start_north
    @start_east = start_east
    @end_north = end_north
    @end_east = end_east
    @dropoff_points = []
  end

  def can_take(order)
    proposed_dropoff_points =
      current_dropoff_points << DropoffPoint.new(north: order.location_north, east: order.location_east, deliverable: order)

    calculate_distance_travelled(proposed_dropoff_points) < vehicle.max_range
  end

  def add_deliverable(deliverable)
    vehicle.add_deliverable(deliverable)
  end

  def finalize
    vehicle.dispatch(start_time + travel_time)
  end

  def current_dropoff_points
    vehicle.orders.map do |o|
      DropoffPoint.new(north: o.location_north, east: o.location_east, deliverable: o)
    end
  end

  def travel_time
    distance = calculate_distance_travelled(current_dropoff_points)

    seconds = distance/30
  end

  def calculate_distance_travelled(dropoff_points)
    total_distance = 0
    current_north = start_north
    current_east = start_east

    dropoff_points.each do |dp|
      length = (current_north - dp.north).abs
      width = (current_east - dp.east).abs
      total_distance += diagonal_distance(length, width)

      dp.deliverable.travel_time = total_distance/30

      current_north = dp.north
      current_east = dp.east
    end

    length = (current_north - end_north).abs
    width = (current_east - end_east).abs
    total_distance += diagonal_distance(length, width)

    total_distance
  end

  def diagonal_distance(length, width)
    Math.sqrt(length ** 2 + width ** 2)
  end
end
