require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "login page renders the branded form" do
    get new_agent_session_url
    assert_response :success
    assert_select "h1", "Welcome back"
  end

  test "signing up creates an agent with a name and signs in" do
    assert_difference -> { Agent.count }, 1 do
      post agent_registration_url, params: {
        agent: { name: "New Agent", email: "new@example.com", password: "secret123", password_confirmation: "secret123" }
      }
    end
    assert_redirected_to root_url
    assert_equal "New Agent", Agent.find_by(email: "new@example.com").name
  end

  test "unauthenticated visitors are sent to login" do
    get root_url
    assert_redirected_to new_agent_session_url
  end
end
