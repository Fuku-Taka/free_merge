class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :address
  has_one :card
  has_many :saling_items, -> { where("seller_id is not NULL && buyer_id is NULL") }, class_name: "Product"
  has_many :sold_items, -> { where("seller_id is not NULL && buyer_id is not NULL") }, class_name: "Product"
  # has_many :auction_items, -> { where("seller_id is not NULL && auction_id is not NULL && buyer_id is NULL") }, class_name: "Product"
  validates :family_name, presence: true
  validates :first_name, presence: true
  validates :family_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :birthday, presence: true
  validates :nickname, presence: true
end
