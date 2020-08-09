class Address < ApplicationRecord
  belongs_to :user, optional: true
  validates :postal_code, presence: true
  validates :postal_code, format: { with: /\A\d{3}[-]\d{4}$|^\d{3}[-]\d{2}$|^\d{3}\z/ }
  validates :prefecture, presence: true
  validates :city, presence: true
  validates :address, presence: true
end
