def resource_factory(file = nil)
  file ||= Refinery.roots(:'refinery/resources').
                    join("spec/fixtures/refinery_is_awesome.txt")

  Resource.create :file => file
end