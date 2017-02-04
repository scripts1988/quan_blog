class Comment < ApplicationRecord
  validates :message, presence: true
end
