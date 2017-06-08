class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def index
    @companies = Company.where("account_name ILIKE ?", "%#{params[:q]}%").order("account_name asc").limit(10)
  end
end
