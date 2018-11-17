class Datum < ApplicationRecord
  belongs_to :statement
  belongs_to :year
  belongs_to :quarter
  belongs_to :company
  belongs_to :page
end
