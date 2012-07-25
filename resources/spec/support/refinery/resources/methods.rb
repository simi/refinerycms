module Refinery
  module Resources
    module Methods
      def resource_factory(file = nil)
        file ||= Refinery.roots(:'refinery/resources').
                          join("spec/fixtures/refinery_is_awesome.txt")

        Resource.new :file => file
      end
    end
  end
end

RSpec.configure do |config|
  config.include Refinery::Resources::Methods
end
