require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
end

require_relative "../lib/zip_scheduler.rb"
require_relative "../lib/hospital_manager.rb"
require_relative "../lib/order_manager.rb"
require_relative "../lib/travel_plan.rb"
require_relative "../lib/zip.rb"
require_relative "../lib/zip_fleet.rb"
