class Image < ApplicationRecord
  belongs_to :content, optional: true
  validates :content_image, presence: true
  mount_uploader :content_image, ImageUploader
end
