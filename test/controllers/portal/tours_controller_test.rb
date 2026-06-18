require "test_helper"

module Portal
  class ToursControllerTest < ActionDispatch::IntegrationTest
    setup do
      @agent = agents(:janey)
      @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
      @tour = @agent.tours.create!(client: @client, name: "Highlands Weekend", status: "confirmed")
      @tour.properties.create!(address: "3301 Osceola St", city: "Denver, CO")
      @token = @client.portal_token
    end

    test "index lists the client's tours without login" do
      get portal_client_tours_url(@token)
      assert_response :success
      assert_select "body", /Highlands Weekend/
    end

    test "show renders stops and rating buttons" do
      get portal_client_tour_url(@token, @tour)
      assert_response :success
      assert_select "body", /Osceola St/
      assert_select "body", /Your reaction/
    end

    test "invalid token is rejected" do
      get portal_client_tours_url("bogustoken")
      assert_response :not_found
    end

    test "client sends a message" do
      assert_difference -> { @tour.messages.count }, 1 do
        post portal_client_tour_messages_url(@token, @tour), params: { body: "Looks great!" }, as: :turbo_stream
      end
      assert_equal "client", @tour.messages.last.sender_type
    end
  end
end
