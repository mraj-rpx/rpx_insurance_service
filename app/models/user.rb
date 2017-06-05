class User < ApplicationRecord
  self.table_name = 'rpx_user.users'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company, foreign_key: 'account_id', primary_key: 'rpx_id'
  delegate :name, to: :company, prefix: true
  has_many :user_role_users
  has_many :user_roles, :through => :user_role_users

  def has_role?(role_name)
    user_roles.map(&:name).include?(role_name)
  end
end
