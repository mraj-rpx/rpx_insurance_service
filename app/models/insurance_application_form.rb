class InsuranceApplicationForm < ApplicationRecord
  mount_uploader :file, InsuranceApplicationFormUploader
  has_many :insurance_application_filled_forms
end
