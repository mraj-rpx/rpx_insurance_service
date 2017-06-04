class Company < ApplicationRecord
  self.table_name = 'sf.accounts'
  alias_attribute :name, :account_name
  has_many :insurance_application_filled_forms
end
