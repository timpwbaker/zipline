#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zip_fleet'
require 'order_manager'
require 'hospital_manager'
require 'zip_scheduler'

hospitals_csv = ARGV[0]
orders_csv = ARGV[1]

hospital_manager = HospitalManager.new(hospitals_csv)
order_manager = OrderManager.new(orders_csv, hospital_manager)
zip_fleet = ZipFleet.new()

zip_scheduler = ZipScheduler.new(
  order_manager: order_manager,
  hospital_manager: hospital_manager,
  zip_fleet: zip_fleet)

current_time = 0
end_time = 24*60*60

schedule_count = 0

emergency_dispatch_delays = []
resupply_dispatch_delays = []

emergency_order_durations = []
resupply_order_durations = []

while current_time < end_time
  schedule = zip_scheduler.schedule_next_flight(current_time)
  if schedule

    emergency_dispatch_delays << schedule[:orders]
      .select{|o| o[:priority] == "Emergency"}.map{|o| o[:dispatch_delay]}
    resupply_dispatch_delays << schedule[:orders]
      .select{|o| o[:priority] == "Resupply"}.map{|o| o[:dispatch_delay]}

    emergency_order_durations << schedule[:orders]
      .select{|o| o[:priority] == "Emergency"}.map{|o| o[:order_duration]}
    resupply_order_durations << schedule[:orders]
      .select{|o| o[:priority] == "Resupply"}.map{|o| o[:order_duration]}

    schedule_count += 1
  end
  current_time += 30
end

orders_count = [emergency_dispatch_delays, resupply_dispatch_delays].flatten.length
emergency_dispatch_delay = emergency_dispatch_delays.flatten.inject{ |sum, el| sum + el }.to_f / emergency_dispatch_delays.size
resupply_dispatch_delay = resupply_dispatch_delays.flatten.inject{ |sum, el| sum + el }.to_f / resupply_dispatch_delays.size

emergency_order_duration = emergency_order_durations.flatten.inject{ |sum, el| sum + el }.to_f / emergency_order_durations.size
resupply_order_duration = resupply_order_durations.flatten.inject{ |sum, el| sum + el }.to_f / resupply_order_durations.size


puts "Delivered #{orders_count} orders over #{schedule_count} flights"
puts "\n"
puts "Average emergency dispatch delay: #{emergency_dispatch_delay}"
puts "Average resupply dispatch delay: #{resupply_dispatch_delay}"
puts "\n"
puts "Average emergency order duration: #{emergency_order_duration}"
puts "Average resupply order duration: #{resupply_order_duration}"
