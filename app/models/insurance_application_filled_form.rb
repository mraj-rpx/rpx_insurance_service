class InsuranceApplicationFilledForm < ApplicationRecord
  belongs_to :insurance_application_form
  belongs_to :company, foreign_key: 'company_id', primary_key: 'rpx_id'
  belongs_to :user_modified, foreign_key: 'modified_by', primary_key: 'id', class_name: "User"
  before_save :update_modified_by
  before_validation :update_modified_by
  delegate :name, to: :company, prefix: true
  delegate :file_hash, to: :insurance_application_form
  delegate :name, to: :insurance_application_form, prefix: true
  validates :company_id, presence: true
  validates :insurance_application_form_id, presence: true
  enum status: {DRAFT: 0, PUBLISHED: 1}

  def self.fetch_data(params)
    query = joins(:insurance_application_form)
    .joins(:company)
    .joins(:user_modified)
    .select("insurance_application_filled_forms.id, users.first_name, users.last_name, insurance_application_filled_forms.status, insurance_application_filled_forms.updated_at, accounts.account_name, accounts.account_name as company_name, insurance_application_forms.name as application_type, CONCAT('Application-', insurance_application_filled_forms.id) as application_number")
    order_string = []
    params[:order].keys.each do |key|
      order_string << "#{params['columns'][params[:order][key]["column"]]["data"]} #{params[:order][key]["dir"]}"
    end
    query.order(order_string.join(", ")).limit(params[:length] || 10).offset(params[:start] || 0)
  end

  private
  def update_modified_by
    self.modified_by = User.current.id
  end
end
