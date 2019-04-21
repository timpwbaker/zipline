require 'hospital'
require 'csv'

class HospitalManager
  attr_reader :hospitals

  def initialize(hospitals_csv)
    @hospitals_csv = hospitals_csv
    @hospitals = parse_hospitals
  end

  def find_hospital_by_name(name)
    hospitals.find{ |h| h.name.downcase.strip == name.downcase.strip }
  end

  private

  def parse_hospitals
    hospitals = []

    CSV.foreach(@hospitals_csv) do |row|
      raise ArgumentError.new("Invalid row: #{row}") if invalid_row(row)

      hospitals << Hospital.new(
        name: row[0],
        north: row[1].to_f,
        east: row[2].to_f
      )
    end

    hospitals
  end

  def invalid_row(row)
    row[0].to_s.empty? || row[1].to_s.empty? || row[2].to_s.empty?
  end
end
