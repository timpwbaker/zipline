class Order
  attr_accessor :received_time, :location_name, :location_north, :location_east, :priority, :travel_time

  def initialize(received_time:, location_name:, location_north:, location_east:, priority:)
    raise ArgumentError if !valid_priority(priority)

    @received_time = received_time
    @location_name = location_name
    @location_north = location_north
    @location_east = location_east
    @priority = priority
    @dispatched = false
  end

  def dispatch
    @dispatched = true
  end

  def dispatched
    @dispatched
  end

  def emergency
    priority.downcase == "emergency"
  end

  private

  def valid_priority(priority)
    priority.downcase == "emergency" ||
      priority.downcase == "resupply"
  end

end
