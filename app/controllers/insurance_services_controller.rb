require 'net/http/post/multipart'

class InsuranceServicesController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_app_form, only: [:new]
  before_action :set_app_filled_form, only: [:edit]
  before_action :set_file_path, only: [:edit]

  def index
    @filled_forms = InsuranceApplicationFilledForm.order(created_at: :desc).where(company_id: current_user.account_id)
  end

  def new
    @app_form_new = InsuranceApplicationFilledForm.new
    render :layout => false
  end

  def create
    @app_form = InsuranceApplicationFilledForm.create(permit_params)
    render json: {success: true}
  end

  def edit
  end

  def update
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    if request.xhr?
      params[:insurance_application_filled_form][:xml] = params[:insurance_application_filled_form][:xml].gsub(/&/, "&amp;") if params[:insurance_application_filled_form] && params[:insurance_application_filled_form][:xml]
      @app_form.update_attributes(permit_params)
      render json: {success: true}
    else 
      params[:insurance_application_filled_form][:xml] = params[:insurance_application_filled_form][:xml].gsub(/&/, "&amp;") if params[:insurance_application_filled_form] && params[:insurance_application_filled_form][:xml]
      @app_form.update_attributes(permit_params)
      redired_condition = params[:insurance_application_filled_form][:admin_edit] == "true"
      redirect_to (redired_condition ? admin_insurance_applications_path : insurance_services_path), notice: 'Successfully updated the insurance application form.'
    end
  end

  def select_form
    @ins_app_forms = InsuranceApplicationForm.all
  end

  def form_xml_content
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    render xml: (@app_form.xml || "<fields xmlns:xfdf='http://ns.adobe.com/xfdf-transition/'></fields>")
  end

  def download_pdf
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    uri = URI.parse("http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/asserts/#{@app_form.file_hash}/exportDocument?accessToken=#{ENV['ACCESS_TOKEN']}")
    request = Net::HTTP::Post::Multipart.new(uri.path, {
                                           fileName: File.open(Rails.root.join("public/#{@app_form.insurance_application_form.file.url}")),
                                           formData: @app_form.xml,
                                           annotsData: '[]',
                                           inkData: nil,
                                           language: 'en-US',
                                           watermarkInfo: '[]'
                                             })
    response = Net::HTTP.start(uri.host, uri.port){ |http| http.request(request) }
    send_data response.body, filename: @app_form.insurance_application_form[:file]
  end

  private

  def set_app_form
    @ins_app_form = InsuranceApplicationForm.find(params[:ins_app_form_id])
  end

  def set_app_filled_form
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    @ins_app_form = @app_form.insurance_application_form
  end

  def set_file_path
    @form_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}#{@ins_app_form.file.url}"
  end

  def permit_params
    params.require(:insurance_application_filled_form).permit(:xml, :status, :insurance_application_form_id, :company_id)
  end
end
