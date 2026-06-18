class Tour < ApplicationRecord
  STATUSES = %w[draft confirmed completed].freeze

  belongs_to :agent
  belongs_to :client
  has_many :properties, -> { order(:position) }, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  # Notifications keep the agent's activity history; just clear the tour link.
  has_many :notifications, dependent: :nullify

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :upcoming, -> { where("tour_date >= ?", Date.current) }

  def past?
    tour_date.present? && tour_date < Date.current
  end

  # Clones the tour (back to draft) along with its property stops.
  def duplicate!
    dup_tour = agent.tours.create!(
      client: client,
      name: "#{name} (Copy)",
      tour_date: tour_date,
      tour_time: tour_time,
      status: "draft"
    )
    properties.each do |property|
      dup_tour.properties.create!(
        property.attributes.slice("address", "city", "beds", "baths", "price", "mls_id", "notes")
      )
    end
    dup_tour
  end
end
