class User < ApplicationRecord
  acts_as_tenant(:organization)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :full_name, presence: true
end
