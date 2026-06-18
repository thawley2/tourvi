require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    @other = agents(:marcus)
    sign_in @agent
    @client = @agent.clients.create!(name: "Sarah Chen", stage: "Touring", pre_approved: "Yes")
  end

  test "requires authentication" do
    sign_out @agent
    get clients_url
    assert_redirected_to new_agent_session_url
  end

  test "index lists the agent's clients" do
    get clients_url
    assert_response :success
    assert_select "body", /Sarah Chen/
  end

  test "creates a client and generates a portal token" do
    assert_difference -> { @agent.clients.count }, 1 do
      post clients_url, params: { client: { name: "New Buyer", stage: "Searching", pre_approved: "No" } }
    end
    client = @agent.clients.order(:created_at).last
    assert_redirected_to client_url(client)
    assert client.portal_token.present?
  end

  test "rejects invalid client" do
    assert_no_difference -> { Client.count } do
      post clients_url, params: { client: { name: "", stage: "Searching", pre_approved: "No" } }
    end
    assert_response :unprocessable_entity
  end

  test "updates a client" do
    patch client_url(@client), params: { client: { stage: "Closed" } }
    assert_redirected_to client_url(@client)
    assert_equal "Closed", @client.reload.stage
  end

  test "destroys a client" do
    assert_difference -> { Client.count }, -1 do
      delete client_url(@client)
    end
    assert_redirected_to clients_url
  end

  test "cannot access another agent's client" do
    stranger = @other.clients.create!(name: "Not Mine", stage: "Searching", pre_approved: "No")
    get client_url(stranger)
    assert_response :not_found
  end
end
