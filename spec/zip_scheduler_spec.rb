require 'spec_helper'

RSpec.describe ZipScheduler, ".initialize" do
  it "takes an order_manager hospital_manager and zip_fleet" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    zip_fleet = ZipFleet.new()

    zip_scheduler = ZipScheduler.new(
      order_manager: order_manager,
      hospital_manager: hospital_manager,
      zip_fleet: zip_fleet)

    expect(zip_scheduler.zip_fleet).to eq zip_fleet
    expect(zip_scheduler.hospital_manager).to eq hospital_manager
    expect(zip_scheduler.order_manager).to eq order_manager
  end
end

RSpec.describe ZipScheduler, "#queue_order" do
  it "raises an error if the input is invalid" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    zip_fleet = ZipFleet.new()

    zip_scheduler = ZipScheduler.new(
      order_manager: order_manager,
      hospital_manager: hospital_manager,
      zip_fleet: zip_fleet)

    expect{
      zip_scheduler.queue_order(25893, hospital, "Foobar")
    }.to raise_error ArgumentError

  end

  it "adds an order to the order_manager" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    zip_fleet = ZipFleet.new()

    zip_scheduler = ZipScheduler.new(
      order_manager: order_manager,
      hospital_manager: hospital_manager,
      zip_fleet: zip_fleet)

    expect(zip_scheduler.order_manager.resupply_orders(25894).map(&:received_time)).not_to include(25893)

    zip_scheduler.queue_order(25893, hospital, "Resupply")

    expect(zip_scheduler.order_manager.resupply_orders(25894).map(&:received_time)).to include(25893)
  end
end

RSpec.describe ZipScheduler, "#schedule_next_flight" do
  it "adds an order to the order_manager" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)
    zip_fleet = ZipFleet.new()

    zip_scheduler = ZipScheduler.new(
      order_manager: order_manager,
      hospital_manager: hospital_manager,
      zip_fleet: zip_fleet)

    zip_scheduler.queue_order(25893, hospital, "Resupply")

    flight = zip_scheduler.schedule_next_flight(25894)

    expect(flight[:orders].length).to eq 2
    expect(flight[:orders].first[:priority]).to eq "Emergency"
    expect(flight[:orders].last[:priority]).to eq "Resupply"
  end
end
