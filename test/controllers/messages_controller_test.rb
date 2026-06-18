require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Tour", status: "confirmed")
  end

  test "agent sends a message" do
    assert_difference -> { @tour.messages.count }, 1 do
      post tour_messages_url(@tour), params: { body: "On my way!" },
        as: :turbo_stream
    end
    message = @tour.messages.last
    assert_equal "agent", message.sender_type
    assert_equal @agent.id, message.sender_id
  end

  test "blank message is ignored" do
    assert_no_difference -> { @tour.messages.count } do
      post tour_messages_url(@tour), params: { body: "" }, as: :turbo_stream
    end
  end

  test "client message creates a notification for the agent" do
    assert_difference -> { @agent.notifications.count }, 1 do
      @tour.messages.create!(sender_type: "client", sender_id: @client.id, body: "Hi!")
    end
    assert_equal "message", @agent.notifications.last.notif_type
  end
end
