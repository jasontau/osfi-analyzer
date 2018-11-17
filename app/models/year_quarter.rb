class YearQuarter < ApplicationRecord
  belongs_to :year
  belongs_to :quarter

  validates :quarter, presence: true, uniqueness: { scope: :year, message: "no duplicate quarters per year" }
  validates :year, presence: true
end
