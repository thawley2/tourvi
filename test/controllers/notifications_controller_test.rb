require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Tour", status: "confirmed")
    @notification = @agent.notifications.create!(tour: @tour, notif_type: "message", body: "New message")
  end

  test "index lists notifications" do
    get notifications_url
    assert_response :success
    assert_select "body", /New message/
  end

  test "opening a notification marks it read and redirects to the tour" do
    patch notification_url(@notification)
    assert @notification.reload.read?
    assert_redirected_to tour_url(@tour)
  end

  test "mark all read clears unread" do
    @agent.notifications.create!(notif_type: "rating", body: "A rating")
    patch notification_reads_url
    assert_equal 0, @agent.notifications.unread.count
  end

  test "bell badge appears in nav when unread" do
    get root_url
    assert_select "##{ActionView::RecordIdentifier.dom_id(@agent, :bell)}"
  end
end
