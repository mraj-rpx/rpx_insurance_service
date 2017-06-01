class AddCompanyIdToInsuranceApplicationFilledForm < ActiveRecord::Migration[5.1]
  def change
    add_column :insurance_application_filled_forms, :company_id, :integer, index: true
  end
end
