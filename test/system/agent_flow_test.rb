require "application_system_test_case"

class AgentFlowTest < ApplicationSystemTestCase
  setup { @agent = agents(:janey) }

  test "agent creates a client, builds a tour, and adds a stop" do
    sign_in_as @agent

    click_on "+ Client"
    fill_in "Name", with: "Test Buyers"
    select "Touring", from: "Stage"
    click_on "Add Client"
    assert_text "Test Buyers"

    click_on "+ New Tour"
    fill_in "Tour name", with: "Test Tour"
    select "Test Buyers", from: "Client"
    click_on "Create Tour"
    assert_text "Test Tour"

    find("summary", text: "Add a property").click
    fill_in "Address", with: "123 Demo St"
    click_on "Add property"
    assert_text "123 Demo St"
  end

  test "agent publishes a tour" do
    client = @agent.clients.create!(name: "Pub Client", stage: "Touring", pre_approved: "Yes")
    tour = @agent.tours.create!(client: client, name: "Publish Me", status: "draft")
    tour.properties.create!(address: "1 St")

    sign_in_as @agent
    visit tour_path(tour)
    click_on "Publish"
    assert_text "confirmed"
  end
end
