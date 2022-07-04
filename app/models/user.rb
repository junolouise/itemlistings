class User < ApplicationRecord
  has_many :items

  validates :name, :display_picture, presence: true
end
