class Page < ApplicationRecord
  has_many :data

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
