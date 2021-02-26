Rails.application.routes.draw do
  devise_for :users
  root to: 'rooms#index'
  resources :users, only: :show
  resources :rooms do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end
end
 