require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  setup do
    @agent = agents(:janey)
    @client = @agent.clients.create!(name: "Sarah", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Tour", status: "draft")
  end

  test "acts_as_list assigns sequential positions scoped to the tour" do
    a = @tour.properties.create!(address: "A")
    b = @tour.properties.create!(address: "B")
    c = @tour.properties.create!(address: "C")
    assert_equal [ 1, 2, 3 ], [ a.position, b.position, c.position ]

    c.insert_at(1)
    assert_equal [ c.id, a.id, b.id ], @tour.properties.order(:position).pluck(:id)
  end

  test "requires an address" do
    assert_not @tour.properties.new(address: "").valid?
  end
end
