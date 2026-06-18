class Notification < ApplicationRecord
  belongs_to :agent
  belongs_to :tour, optional: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  ICONS = { "message" => "💬", "suggestion" => "🏠", "rating" => "⭐" }.freeze

  after_create_commit :broadcast_bell

  def icon
    ICONS.fetch(notif_type, "🔔")
  end

  private

  # Refresh the nav bell (badge + dropdown) live for the agent.
  def broadcast_bell
    broadcast_replace_to(
      [ agent, :notifications ],
      target: ActionView::RecordIdentifier.dom_id(agent, :bell),
      partial: "notifications/bell",
      locals: { agent: agent }
    )
  end
end
