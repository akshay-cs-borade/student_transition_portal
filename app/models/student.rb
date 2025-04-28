class Student < ApplicationRecord
  belongs_to :family

  validates :name, presence: true
  validates :grade, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
end
