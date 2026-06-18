require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Highlands Weekend", status: "draft")
    @tour.properties.create!(address: "1 First St")
    @tour.properties.create!(address: "2 Second St")
  end

  test "show renders the tour with stops" do
    get tour_url(@tour)
    assert_response :success
    assert_select "body", /Highlands Weekend/
    assert_select "body", /First St/
  end

  test "creates a tour" do
    assert_difference -> { @agent.tours.count }, 1 do
      post tours_url, params: { tour: { name: "New Tour", client_id: @client.id, status: "draft" } }
    end
    assert_redirected_to tour_url(@agent.tours.order(:created_at).last)
  end

  test "publishing sets status to confirmed" do
    patch tour_url(@tour), params: { tour: { status: "confirmed" } }
    assert_equal "confirmed", @tour.reload.status
  end

  test "duplicate clones the tour and its stops" do
    assert_difference -> { @agent.tours.count }, 1 do
      post tour_duplicate_url(@tour)
    end
    copy = @agent.tours.order(:created_at).last
    assert_equal "Highlands Weekend (Copy)", copy.name
    assert_equal 2, copy.properties.count
    assert_equal "draft", copy.status
  end

  test "destroys a tour" do
    assert_difference -> { Tour.count }, -1 do
      delete tour_url(@tour)
    end
    assert_redirected_to root_url
  end

  test "destroys a tour that has notifications" do
    notification = @agent.notifications.create!(tour: @tour, notif_type: "message", body: "Hi")
    assert_difference -> { Tour.count }, -1 do
      delete tour_url(@tour)
    end
    assert_nil notification.reload.tour_id
  end
end

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Tour", status: "draft")
    @a = @tour.properties.create!(address: "A St")
    @b = @tour.properties.create!(address: "B St")
    @c = @tour.properties.create!(address: "C St")
  end

  test "adds a property to the tour" do
    assert_difference -> { @tour.properties.count }, 1 do
      post tour_properties_url(@tour), params: { property: { address: "D St" } }
    end
    assert_equal 4, @tour.properties.last.position
  end

  test "updates agent notes" do
    patch tour_property_url(@tour, @a), params: { property: { notes: "Great light" } }
    assert_equal "Great light", @a.reload.notes
  end

  test "reorders via position param" do
    patch tour_property_url(@tour, @c), params: { property: { position: 1 } }
    assert_response :ok
    assert_equal [ @c.id, @a.id, @b.id ], @tour.properties.order(:position).pluck(:id)
  end

  test "removes a property" do
    assert_difference -> { @tour.properties.count }, -1 do
      delete tour_property_url(@tour, @b)
    end
  end
end
