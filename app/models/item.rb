class Item < ApplicationRecord
  belongs_to :user

  validates :title, :thumbnail_url, :distance, presence: true
end
