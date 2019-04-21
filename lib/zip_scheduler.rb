require 'travel_plan'

class ZipScheduler
  attr_reader :order_manager, :hospital_manager, :zip_fleet, :current_time

  def initialize(order_manager:, hospital_manager:, zip_fleet:)
    @order_manager = order_manager
    @hospital_manager = hospital_manager
    @zip_fleet = zip_fleet
  end

  def queue_order(received_time, hospital, priority)
    order_manager.queue_order(received_time.to_i, hospital, priority)
  end

  def schedule_next_flight(current_time)
    @current_time = current_time

    return if emergency_orders.empty? && late_resupply_orders.empty?

    zip = zip_fleet.reserve_zip(current_time)

    if zip
      plan_flight(zip)
    end
  end

  private

  def plan_flight(zip)
    travel_plan = TravelPlan.new(vehicle: zip, start_time: current_time)

    emergency_orders.each do |eo|
      break if !zip.has_capacity
      travel_plan.add_deliverable(eo) if travel_plan.can_take(eo)
    end

    late_resupply_orders.each do |lo|
      break if !zip.has_capacity
      travel_plan.add_deliverable(lo) if travel_plan.can_take(lo)
    end

    resupply_orders.each do |ro|
      break if !zip.has_capacity
      travel_plan.add_deliverable(ro) if travel_plan.can_take(ro)
    end

    travel_plan.finalize

    {
      time: current_time,
      orders: zip.orders.map{ |o| {
        priority: o.priority,
        ordered_at: o.received_time,
        delivered_at: o.travel_time + current_time,
        dispatch_delay: current_time - o.received_time,
        order_duration: current_time + o.travel_time - o.received_time,
        travel_time: o.travel_time
      }},
      vehicle_id: zip.id,
      hospitals: zip.orders.map(&:location_name),
      return_time: zip.return_time
    }
  end

  private

  def emergency_orders
    order_manager.emergency_orders(current_time)
  end

  def resupply_orders
    order_manager.resupply_orders(current_time)
  end

  def late_resupply_orders
    order_manager.late_resupply_orders(current_time)
  end
end
