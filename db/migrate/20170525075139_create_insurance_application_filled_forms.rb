class CreateInsuranceApplicationFilledForms < ActiveRecord::Migration[5.1]
  def change
    create_table :insurance_application_filled_forms do |t|
      t.integer :user_id
      t.references :insurance_application_form, foreign_key: true, index: {name: 'ins_app_form_id_idx'}
      t.integer :status
      t.string :xml
      t.datetime :submitted_at
      t.timestamps
    end
  end
end
