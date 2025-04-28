class Family < ApplicationRecord
  belongs_to :school
  has_many :students, dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
