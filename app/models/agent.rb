class Agent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clients, dependent: :destroy
  has_many :tours, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true

  def initials
    (name.presence || email).split(/\s+/).filter_map { |w| w[0] }.first(2).join.upcase
  end
end
