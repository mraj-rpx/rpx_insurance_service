class InsuranceApplicationsController < ApplicationController
  before_action :authenticate_user!
  def index
    if request.xhr?
      @count = InsuranceApplicationFilledForm.count
      @data = InsuranceApplicationFilledForm.fetch_data(params)
    end
    @app_form_new = InsuranceApplicationFilledForm.new
  end
end
