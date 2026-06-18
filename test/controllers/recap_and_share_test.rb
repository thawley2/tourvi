require "test_helper"

class RecapAndShareTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", email: "s@e.com", phone: "720-555-0000", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Highlands Weekend", status: "confirmed", tour_date: Date.new(2026, 6, 10))
    @p1 = @tour.properties.create!(address: "3301 Osceola St", city: "Denver", price: "$725,000")
    @p2 = @tour.properties.create!(address: "4150 W 38th Ave", city: "Denver", price: "$658,000")
    Rating.create!(property: @p1, client: @client, value: 3)
  end

  test "recap page shows the recap text with stops and top pick" do
    get tour_recap_url(@tour)
    assert_response :success
    assert_select "textarea", /Osceola St/
    assert_select "textarea", /Top pick/
  end

  test "share page shows the portal link" do
    get tour_share_url(@tour)
    assert_response :success
    assert_select "input[value=?]", portal_client_tours_url(@client.portal_token)
  end
end
