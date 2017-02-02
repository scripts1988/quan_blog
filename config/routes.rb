Rails.application.routes.draw do
  resources :articles do
    collection do
      get :search, :action => 'search_post', :as => 'search_post'
      get 'search/:q', :action => 'search', :as => 'search'
      get 'details/:id', :action => 'details', :as => 'details'
      post ':id/comment', :action => 'comment', :as => 'comment'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
