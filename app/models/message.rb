class Message < ApplicationRecord
  SENDER_TYPES = %w[agent client].freeze

  belongs_to :tour

  validates :body, presence: true
  validates :sender_type, inclusion: { in: SENDER_TYPES }

  after_create_commit :broadcast_message
  after_create_commit :notify_agent

  def from_agent?
    sender_type == "agent"
  end

  def sender_name
    from_agent? ? tour.agent.name : tour.client.name
  end

  def sender_initials
    sender_name.split(/\s+/).filter_map { |w| w[0] }.first(2).join.upcase
  end

  private

  # Broadcast to the agent and client streams separately so each side renders
  # the bubble from its own viewpoint (sent vs received alignment).
  def broadcast_message
    target = ActionView::RecordIdentifier.dom_id(tour, :messages)
    %w[agent client].each do |viewer|
      broadcast_append_to(
        [ tour, viewer ], target: target,
        partial: "messages/message", locals: { message: self, viewer: viewer }
      )
    end
  end

  def notify_agent
    return unless sender_type == "client"

    tour.agent.notifications.create!(
      tour: tour,
      notif_type: "message",
      body: "#{tour.client.name} sent a message on #{tour.name}"
    )
  end
end
