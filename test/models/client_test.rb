require "test_helper"

class ClientTest < ActiveSupport::TestCase
  setup { @agent = agents(:janey) }

  test "generates a unique portal token on create" do
    a = @agent.clients.create!(name: "A", stage: "Searching", pre_approved: "No")
    b = @agent.clients.create!(name: "B", stage: "Searching", pre_approved: "No")
    assert a.portal_token.present?
    assert_not_equal a.portal_token, b.portal_token
  end

  test "validates stage and pre_approved values" do
    assert_not @agent.clients.new(name: "X", stage: "Nope", pre_approved: "No").valid?
    assert_not @agent.clients.new(name: "X", stage: "Searching", pre_approved: "Maybe").valid?
  end

  test "destroying a client destroys its tours" do
    client = @agent.clients.create!(name: "C", stage: "Searching", pre_approved: "No")
    @agent.tours.create!(client: client, name: "T", status: "draft")
    assert_difference -> { Tour.count }, -1 do
      client.destroy
    end
  end
end
