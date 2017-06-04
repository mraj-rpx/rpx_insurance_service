class User < ApplicationRecord
  self.table_name = 'rpx_user.users'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
end
