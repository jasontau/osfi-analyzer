class Quarter < ApplicationRecord
  has_many :data
  has_many :year_quarters
  has_many :years, through: :year_quarters

  validates :quarter, presence: true, uniqueness: true
end
