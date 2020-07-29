class Category < ApplicationRecord
  has_many :contents
  has_ancestry
end
