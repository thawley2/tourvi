require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent = agents(:janey)
    sign_in @agent
  end

  test "show renders the profile" do
    get profile_url
    assert_response :success
    assert_select "body", /Janey Hawley/
  end

  test "updates profile fields" do
    patch profile_url, params: { agent: { brokerage: "New Brokerage", profile_color: "#7B9E87" } }
    assert_redirected_to profile_url
    assert_equal "New Brokerage", @agent.reload.brokerage
    assert_equal "#7B9E87", @agent.profile_color
  end

  test "uploads an avatar" do
    file = fixture_file_upload(Rails.root.join("public/icon.png"), "image/png")
    patch profile_url, params: { agent: { avatar: file } }
    assert @agent.reload.avatar.attached?
  end
end
