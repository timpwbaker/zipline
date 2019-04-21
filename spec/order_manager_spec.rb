require "spec_helper"

RSpec.describe OrderManager, ".initialize" do
  it "accepts the location of a csv file as an argument" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)

    expect(order_manager.orders.map(&:received_time))
      .to eq [25803, 25892, 25967]
  end

  it "returns errors when imported csv is invalid" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")

    expect{
      OrderManager.new("spec/fixtures/test_invalid_orders.csv", hospital_manager)
    }.to raise_error ArgumentError
  end
end

RSpec.describe OrderManager, "#emergency_orders" do
  it "returns the emergency orders" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)

    expect(order_manager.emergency_orders(25893).map(&:received_time))
      .to eq [25803]
  end
end

RSpec.describe OrderManager, "#resupply_orders" do
  it "returns the resupply_orders" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)

    expect(order_manager.resupply_orders(25893).map(&:received_time))
      .to eq [25892]
  end
end

RSpec.describe OrderManager, "#late_resupply_orders" do
  it "returns the late resupply_orders orders" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)

    expect(order_manager.late_resupply_orders(25893).map(&:received_time))
      .to eq []
    expect(order_manager.late_resupply_orders(65893).map(&:received_time))
      .to eq [25892, 25967]
  end
end

RSpec.describe OrderManager, "#queue_order" do
  it "enqueues a new order" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")
    hospital = hospital_manager.hospitals.first
    order_manager = OrderManager.new("spec/fixtures/test_orders.csv", hospital_manager)

    order_manager.queue_order(25893, hospital, "Resupply")

    expect(order_manager.resupply_orders(25894).map(&:received_time))
      .to eq [25892, 25893]
  end
end
