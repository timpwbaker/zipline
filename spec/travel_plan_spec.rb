require 'spec_helper'

RSpec.describe TravelPlan, ".initialize" do
  it "takes a vehicle and a start time" do
    zip = Zip.new(id: 1, max_deliveries: 3, max_range: 160000)
    travel_plan = TravelPlan.new(vehicle: zip, start_time: 25803)

    expect(travel_plan.vehicle).to eq zip
    expect(travel_plan.start_time).to eq 25803
    expect(travel_plan.start_east).to eq 0
    expect(travel_plan.start_north).to eq 0
    expect(travel_plan.end_east).to eq 0
    expect(travel_plan.end_north).to eq 0
  end
end


RSpec.describe TravelPlan, "#can_take" do
  it "returns true or false depending on whether the order can be accepted" do
    zip = Zip.new(id: 1, max_deliveries: 3, max_range: 160000)
    travel_plan = TravelPlan.new(vehicle: zip, start_time: 25803)
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    order = order_manager.orders[0]
    not_stackable = order_manager.orders[1]
    stackable = order_manager.orders[2]

    expect(travel_plan.can_take(order)).to be true
    travel_plan.add_deliverable(order)

    expect(travel_plan.can_take(not_stackable)).to be false
    expect(travel_plan.can_take(stackable)).to be true
  end
end

RSpec.describe TravelPlan, "#finalize" do
  it "dispatches the vehicle and underlying orders" do
    zip = Zip.new(id: 1, max_deliveries: 3, max_range: 160000)
    travel_plan = TravelPlan.new(vehicle: zip, start_time: 25803)
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    order = order_manager.orders[0]
    stackable = order_manager.orders[2]

    travel_plan.add_deliverable(order)
    travel_plan.add_deliverable(stackable)

    travel_plan.finalize

    expect(zip.return_time).to eq 30182.120471969567
    expect(order.dispatched).to eq true
    expect(stackable.dispatched).to eq true
  end
end

