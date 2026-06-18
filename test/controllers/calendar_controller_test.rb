require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "June Tour", status: "confirmed", tour_date: Date.new(2026, 6, 10))
  end

  test "renders the month grid with tours" do
    get calendar_url(month: 6, year: 2026)
    assert_response :success
    assert_select "body", /June Tour/
    assert_select "body", /June 2026/
  end

  test "defaults to the current month" do
    get calendar_url
    assert_response :success
  end

  test "dragging a tour to a new date updates tour_date" do
    patch tour_url(@tour), params: { tour: { tour_date: "2026-06-20" } }
    assert_equal Date.new(2026, 6, 20), @tour.reload.tour_date
  end
end
