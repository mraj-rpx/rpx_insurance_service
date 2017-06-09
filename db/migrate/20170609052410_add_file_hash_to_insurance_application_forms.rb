class AddFileHashToInsuranceApplicationForms < ActiveRecord::Migration[5.1]
  def change
    add_column :insurance_application_forms, :file_hash, :string
  end
end
