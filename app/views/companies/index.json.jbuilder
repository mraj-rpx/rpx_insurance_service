json.results @companies do |company|
  json.id company.rpx_id
  json.text company.account_name
end