class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :creditcard
  has_one :address
  has_many :contents
  validates :nickname, presence: true
  # validates :address, presence: true
end
