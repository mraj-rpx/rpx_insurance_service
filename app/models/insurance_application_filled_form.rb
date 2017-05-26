class InsuranceApplicationFilledForm < ApplicationRecord
  belongs_to :insurance_application_form
  enum status: {DRAFT: 0, PUBLISHED: 1}
end
