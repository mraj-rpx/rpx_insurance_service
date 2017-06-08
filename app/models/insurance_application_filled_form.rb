class InsuranceApplicationFilledForm < ApplicationRecord
  belongs_to :insurance_application_form
  belongs_to :company, foreign_key: 'company_id', primary_key: 'rpx_id'
  before_save :update_modified_by
  delegate :name, to: :company, prefix: true
  enum status: {DRAFT: 0, PUBLISHED: 1}

  def self.fetch_data(params)
    query = joins(:insurance_application_form)
    .joins(:company)
    .select("insurance_application_filled_forms.id, insurance_application_filled_forms.modified_by, insurance_application_filled_forms.status, insurance_application_filled_forms.updated_at, accounts.account_name, accounts.account_name as company_name, insurance_application_forms.name as application_type, CONCAT('Application-', insurance_application_filled_forms.id) as application_number")
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
