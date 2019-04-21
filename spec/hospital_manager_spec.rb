require "spec_helper"

RSpec.describe HospitalManager, ".initialize" do
  it "accepts the location of a csv file as an argument" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")

    expect(hospital_manager.hospitals.map(&:name))
      .to eq ["Bigogwe", "Butaro", "Byumba"]
  end

  it "returns errors when imported csv is invalid" do
    expect{HospitalManager.new("spec/fixtures/test_invalid_hospitals.csv")}.to raise_error ArgumentError
  end
end

RSpec.describe HospitalManager, "#find_hospital_by_name" do
  it "returns hospital by name" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")

    expect(hospital_manager.find_hospital_by_name("Bigogwe").north)
      .to eq 50316.0
  end

  it "returns nil if there are no hospitals" do
    hospital_manager = HospitalManager.new("spec/fixtures/test_hospitals.csv")

    expect(hospital_manager.find_hospital_by_name("Foobar"))
      .to be_nil
  end
end
