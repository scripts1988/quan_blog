class AddViewToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :view, :integer
  end
end
