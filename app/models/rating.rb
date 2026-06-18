class Rating < ApplicationRecord
  LABELS = { 1 => "Meh", 2 => "Like", 3 => "Love it" }.freeze
  EMOJIS = { 1 => "😐", 2 => "👍", 3 => "❤️" }.freeze

  belongs_to :property
  belongs_to :client

  validates :value, inclusion: { in: LABELS.keys }
  validates :client_id, uniqueness: { scope: :property_id }

  after_save_commit :notify_agent

  def label
    LABELS[value]
  end

  def emoji
    EMOJIS[value]
  end

  private

  def notify_agent
    tour = property.tour
    tour.agent.notifications.create!(
      tour: tour,
      notif_type: "rating",
      body: "#{client.name} reacted #{emoji} to #{property.address}"
    )
  end
end
