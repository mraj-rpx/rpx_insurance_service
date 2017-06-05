class UserRoleUser < ApplicationRecord
  self.table_name = 'portal.user_roles_users'
  belongs_to :user
  belongs_to :user_role
end
