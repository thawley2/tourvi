require "test_helper"

class DashboardAndSearchTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Highlands Weekend", status: "confirmed", tour_date: Date.current)
    @tour.properties.create!(address: "4150 W 38th Ave")
  end

  test "dashboard renders the week widget and tours" do
    get root_url
    assert_response :success
    assert_select "body", /Highlands Weekend/
  end

  test "dashboard accepts a week offset" do
    get root_url(week: 1)
    assert_response :success
  end

  test "search finds tours by name" do
    get search_url(q: "Highlands")
    assert_response :success
    assert_select "body", /Highlands Weekend/
  end

  test "search finds tours by property address" do
    get search_url(q: "38th Ave")
    assert_response :success
    assert_select "body", /Highlands Weekend/
  end

  test "search finds clients by name" do
    get search_url(q: "Sarah")
    assert_response :success
    assert_select "body", /Sarah Chen/
  end

  test "blank search shows prompt" do
    get search_url(q: "")
    assert_response :success
  end
end
