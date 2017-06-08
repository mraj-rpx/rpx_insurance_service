class AddModifiedByInInsuranceApplicationFilledForms < ActiveRecord::Migration[5.1]
  def change
    add_column :insurance_application_filled_forms, :modified_by, :integer, index: true
  end
end
