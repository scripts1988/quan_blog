class Article < ApplicationRecord
  validates :title, :body, presence: true

  def self.search(term)
    where('title LIKE ?', "%#{term}%")
  end
end
