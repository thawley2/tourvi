require "test_helper"

class RatingsAndSuggestionsTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Highlands Weekend", status: "confirmed")
    @property = @tour.properties.create!(address: "3301 Osceola St")
    @token = @client.portal_token
  end

  test "client creates a rating" do
    assert_difference -> { Rating.count }, 1 do
      post portal_client_tour_ratings_url(@token, @tour),
        params: { rating: { property_id: @property.id, value: 3 } }
    end
    assert_equal 3, @property.ratings.first.value
  end

  test "client updates a rating value" do
    rating = Rating.create!(property: @property, client: @client, value: 1)
    patch portal_client_tour_rating_url(@token, @tour, rating), params: { rating: { value: 2 } }
    assert_equal 2, rating.reload.value
  end

  test "client removes a rating" do
    rating = Rating.create!(property: @property, client: @client, value: 2)
    assert_difference -> { Rating.count }, -1 do
      delete portal_client_tour_rating_url(@token, @tour, rating)
    end
  end

  test "rating notifies the agent" do
    assert_difference -> { @agent.notifications.count }, 1 do
      Rating.create!(property: @property, client: @client, value: 3)
    end
  end

  test "client submits a suggestion which notifies the agent" do
    assert_difference -> { Suggestion.count }, 1 do
      assert_difference -> { @agent.notifications.count }, 1 do
        post portal_client_tour_suggestions_url(@token, @tour),
          params: { suggestion: { address: "999 New Listing St", city: "Denver" } }
      end
    end
    assert_equal "pending", Suggestion.last.status
  end

  test "agent approves a suggestion which adds a property" do
    sign_in @agent
    suggestion = @tour.suggestions.create!(client: @client, address: "999 New Listing St")
    assert_difference -> { @tour.properties.count }, 1 do
      patch suggestion_url(suggestion), params: { decision: "approve" }
    end
    assert_equal "approved", suggestion.reload.status
    assert_equal "999 New Listing St", @tour.properties.last.address
  end

  test "agent declines a suggestion" do
    sign_in @agent
    suggestion = @tour.suggestions.create!(client: @client, address: "Nope St")
    assert_no_difference -> { @tour.properties.count } do
      patch suggestion_url(suggestion), params: { decision: "decline" }
    end
    assert_equal "declined", suggestion.reload.status
  end

  test "agent cannot act on another agent's suggestion" do
    sign_in agents(:marcus)
    suggestion = @tour.suggestions.create!(client: @client, address: "X St")
    patch suggestion_url(suggestion), params: { decision: "approve" }
    assert_response :not_found
  end
end
