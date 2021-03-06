json.recordsFiltered @records_filtered
json.recordsTotal @count
json.draw params[:draw]
json.data @data do |datum|
  json.id datum.id
  json.company_name datum.account_name 
  json.company_id datum.company_id
  json.updated_at datum.updated_at.strftime('%m/%d/%Y %H:%M')
  json.status (datum.status == "PUBLISHED" ? "Submitted" : "Draft")
  json.application_type datum.application_type
  json.insurance_application_form_id datum.insurance_application_form_id
  json.modified_by (datum.first_name + " " + datum.last_name)
  json.application_number datum.application_number
end