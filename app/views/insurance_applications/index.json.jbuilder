json.recordsFiltered @count
json.recordsTotal @count
json.draw params[:draw]
json.data @data do |datum|
  json.id datum.id
  json.company_name datum.account_name 
  json.updated_at datum.updated_at.strftime('%m/%d/%Y %H:%M')
  json.status (datum.status ? "Submitted" : "Draft Application")
  json.application_type datum.application_type
  json.application_number datum.application_number
end