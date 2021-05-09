Rails.application.routes.draw do
  resources :comments
  resources :posts do
    collection do
      get :likes
    end
  end
  resources :drafts
  devise_for :users
  root "posts#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
