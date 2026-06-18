require "test_helper"

class TourTest < ActiveSupport::TestCase
  setup do
    @agent = agents(:janey)
    @client = @agent.clients.create!(name: "Sarah", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Tour", status: "confirmed")
    @tour.properties.create!(address: "A St", notes: "nice")
    @tour.properties.create!(address: "B St")
  end

  test "requires a name and valid status" do
    assert_not @agent.tours.new(client: @client, name: "", status: "draft").valid?
    assert_not @agent.tours.new(client: @client, name: "X", status: "bogus").valid?
  end

  test "past? reflects the tour date" do
    assert @agent.tours.new(tour_date: Date.current - 1).past?
    assert_not @agent.tours.new(tour_date: Date.current + 1).past?
  end

  test "duplicate! clones stops as a draft copy" do
    copy = @tour.duplicate!
    assert_equal "Tour (Copy)", copy.name
    assert_equal "draft", copy.status
    assert_equal [ "A St", "B St" ], copy.properties.order(:position).pluck(:address)
    assert_equal "nice", copy.properties.first.notes
  end
end
