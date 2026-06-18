class Property < ApplicationRecord
  belongs_to :tour
  has_many :ratings, dependent: :destroy

  acts_as_list scope: :tour

  validates :address, presence: true

  def maps_query
    [ address, city ].compact_blank.join(" ")
  end
end
