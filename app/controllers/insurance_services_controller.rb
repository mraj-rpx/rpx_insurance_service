require 'net/http/post/multipart'

class InsuranceServicesController < ApplicationController
  before_action :set_app_form, only: [:new]
  before_action :set_app_filled_form, only: [:edit]
  before_action :set_file_path, only: [:new, :edit]

  def index
    @filled_forms = InsuranceApplicationFilledForm.all
  end

  def new
    @app_form_new = InsuranceApplicationFilledForm.new
  end

  def create
    @app_form = InsuranceApplicationFilledForm.create(permit_params)
    redirect_to insurance_services_path, notice: 'Successfully create the insurance application form.'
  end

  def edit
  end

  def update
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    @app_form.update_attributes(permit_params)

    redirect_to insurance_services_path, notice: 'Successfully updated the insurance application form.'
  end

  def select_form
    @ins_app_forms = InsuranceApplicationForm.all
  end

  def form_xml_content
    @app_form = InsuranceApplicationFilledForm.find(params[:id])
    render xml: @app_form.xml
  end

  def download_pdf
    @app_form = InsuranceApplicationFilledForm.find(params[:id])

    uri = URI.parse("http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/asserts/#{ENV['WEB_VIEWER_FORM_HASH']}/exportDocument?accessToken=#{ENV['ACCESS_TOKEN']}")
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
    params.require(:insurance_application_filled_form).permit(:xml, :status, :insurance_application_form_id)
  end
end
