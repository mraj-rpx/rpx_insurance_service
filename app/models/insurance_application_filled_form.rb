class InsuranceApplicationFilledForm < ApplicationRecord
  belongs_to :insurance_application_form
  enum status: {saved: 0, submitted: 1}
end
