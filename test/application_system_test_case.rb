require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Sign in through the UI so the login screen is exercised too.
  def sign_in_as(agent, password: "tourvi123")
    visit new_agent_session_path
    fill_in "Email", with: agent.email
    fill_in "Password", with: password
    click_on "Log in"
    assert_selector "nav", text: "tourvi"
  end
end
