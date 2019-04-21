require 'zip'

class ZipFleet
  attr_accessor :zips

  def initialize(count=10)
    @count = count
    @zips = initialize_zips
  end

  def reserve_zip(time)
    establish_returned_zips(time)

    zip = zips.find(&:available)

    if zip
      zip.in_use = true
    end

    zip
  end

  private

  def establish_returned_zips(time)
    zips.each do |zip|
      if zip.return_time && zip.return_time < time
        zip.in_use = false
        zip.orders = []
      end
    end
  end

  def initialize_zips
    (1..@count).map do |id|
      Zip.new(id: id, max_range: 160000, max_deliveries: 3)
    end
  end
end
