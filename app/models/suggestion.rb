class Suggestion < ApplicationRecord
  STATUSES = %w[pending approved declined].freeze

  belongs_to :tour
  belongs_to :client

  validates :address, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }

  after_create_commit :notify_agent

  # Agent approves: mark approved and append the property to the tour.
  def approve!
    transaction do
      update!(status: "approved")
      tour.properties.create!(address: address, city: city, beds: beds, baths: baths, price: price)
    end
  end

  def decline!
    update!(status: "declined")
  end

  private

  def notify_agent
    tour.agent.notifications.create!(
      tour: tour,
      notif_type: "suggestion",
      body: "#{client.name} suggested #{address} on #{tour.name}"
    )
  end
end
