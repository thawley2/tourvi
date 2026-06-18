require "application_system_test_case"

class PortalFlowTest < ApplicationSystemTestCase
  setup do
    @agent = agents(:janey)
    @client = @agent.clients.create!(name: "Portal Client", stage: "Touring", pre_approved: "Yes")
    @tour = @agent.tours.create!(client: @client, name: "Portal Tour", status: "confirmed")
    @property = @tour.properties.create!(address: "500 Portal Ave", city: "Denver, CO")
  end

  test "client rates a property and sends a message via the portal" do
    visit portal_client_tour_path(@client.portal_token, @tour)
    assert_text "Portal Tour"
    assert_text "500 Portal Ave"

    click_on "❤️ Love it"
    # Wait for the reload to render the active (bold) reaction before asserting.
    assert_selector "button.font-bold", text: "Love it"
    assert_equal 3, @property.ratings.where(client: @client).first&.value

    fill_in "Type a message...", with: "Loved the first stop!"
    click_on "Send"
    assert_text "Loved the first stop!"
  end
end
