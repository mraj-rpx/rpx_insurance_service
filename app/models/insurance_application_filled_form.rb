class InsuranceApplicationFilledForm < ApplicationRecord
  belongs_to :insurance_application_form
  belongs_to :company
  delegate :name, to: :company, prefix: true
  enum status: {DRAFT: 0, PUBLISHED: 1}
end
