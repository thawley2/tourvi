class Client < ApplicationRecord
  STAGES = [ "Searching", "Touring", "Under Contract", "Closed" ].freeze
  PRE_APPROVED = [ "No", "Yes", "In Progress" ].freeze

  belongs_to :agent
  has_many :tours, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :ratings, dependent: :destroy

  before_validation :generate_portal_token, on: :create

  validates :name, presence: true
  validates :stage, inclusion: { in: STAGES }
  validates :pre_approved, inclusion: { in: PRE_APPROVED }
  validates :portal_token, presence: true, uniqueness: true

  def initials
    name.split(/\s+/).filter_map { |w| w[0] }.first(2).join.upcase
  end

  private

  def generate_portal_token
    self.portal_token ||= SecureRandom.urlsafe_base64(16)
  end
end
