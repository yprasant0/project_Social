class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :user
    has_many :likes, as: :likable

    validates :text,  :presence => true
end
