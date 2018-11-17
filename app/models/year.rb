class Year < ApplicationRecord
  has_many :data
  has_many :year_quarters
  has_many :quarters, through: :year_quarters

  validates :year, presence: true, uniqueness: true
end
