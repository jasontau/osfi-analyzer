class Statement < ApplicationRecord
  has_many :data

  validates :statement, presence: true, uniqueness: true
end
