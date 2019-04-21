require 'csv'
require 'order'

class OrderManager
  attr_reader :orders_csv, :hospital_manager
  attr_accessor :orders

  RESUPPLY_MAX_WAIT = 3600

  def initialize(orders_csv, hospital_manager)
    @orders_csv = orders_csv
    @hospital_manager = hospital_manager

    parse_orders
  end

  def emergency_orders(time)
    active_orders(time).select{|o| o.emergency }
  end

  def resupply_orders(time)
    active_orders(time).select{|o| !o.emergency }
  end

  def late_resupply_orders(time)
    resupply_orders(time).select{|o| o.received_time < time - RESUPPLY_MAX_WAIT }
  end

  def queue_order(received_time, hospital, priority)
    @orders << Order.new(
      received_time: received_time,
      location_name: hospital.name,
      location_north: hospital.north,
      location_east: hospital.east,
      priority: priority)
  end

  private

  def active_orders(time)
    @orders.select{ |order| order.received_time <= time && !order.dispatched }
  end

  def parse_orders
    @orders = []

    CSV.foreach(@orders_csv) do |row|
      hospital = hospital_manager.find_hospital_by_name(row[1])

      if invalid_row(row) || !hospital
        raise ArgumentError.new("Invalid row: #{row}")
      end

      @orders << Order.new(
        received_time: row[0].to_i,
        location_name: hospital.name,
        location_north: hospital.north,
        location_east: hospital.east,
        priority: row[2].strip)
    end
  end

  def invalid_row(row)
    row[0].to_s.empty? ||
      !row[0].is_integer? ||
      (row[2].strip != "Resupply" &&
      row[2].strip != "Emergency")
  end
end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end
