class Article < ApplicationRecord
    def self.search(term)
        where('title LIKE ?', "%#{term}%")
    end
end
