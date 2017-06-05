class CreateInsuranceApplicationForms < ActiveRecord::Migration[5.1]
  def change
    create_table :insurance_application_forms do |t|
      t.string :name
      t.string :file
      t.timestamps
    end
  end
end
