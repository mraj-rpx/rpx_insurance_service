class UserRole < ApplicationRecord
  self.table_name = 'portal.user_roles'
  has_many :user_role_users, :dependent => :destroy
  has_many :users, through: :user_role_users
end
