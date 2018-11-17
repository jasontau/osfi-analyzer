class Datum < ApplicationRecord
  belongs_to :statement
  belongs_to :year
  belongs_to :quarter
  belongs_to :company
  belongs_to :page

  validates_associated :statement
  validates_associated :year
  validates_associated :quarter
  validates_associated :company
  validates_associated :page
end
