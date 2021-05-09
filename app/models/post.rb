class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes, as: :likable, dependent: :destroy
  has_many :attachments as: :attachable, dependent: :destroy
  validates :text,  :presence => true
end
