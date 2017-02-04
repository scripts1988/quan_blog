json.extract! article, :id, :title, :body, :created_at, :updated_at, :view
json.url article_url(article, format: :json)
